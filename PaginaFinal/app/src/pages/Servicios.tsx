import { useEffect, useMemo, useState } from 'react'
import { TICKETS, setTickets } from '../data/services'
import { Card, Table, Badge, Tabs, Button, EmptyState, Toast, useToast } from '../components/ui'
import { Icon } from '../components/Icon'
import { serviceTicketService } from '../services'
import { ApiError } from '../services/api'
import type { Role } from '../types'

const STATUS_STYLE: Record<string, { bg: string; color: string }> = {
  'En proceso': { bg: '#fff4dc', color: '#9a6a00' },
  'Listo para recoger': { bg: '#eff6ff', color: '#1d4ed8' },
  Entregado: { bg: '#f0faf4', color: '#15803d' },
  Rechazado: { bg: '#fde9e9', color: '#a33b3b' },
  Abierto: { bg: '#fde9e9', color: '#a33b3b' },
  Resuelto: { bg: '#f0faf4', color: '#15803d' },
}

// Límite de caracteres de la descripción al reportar un problema — mismo
// tope que se usa en el resto del sistema (anuncios, trabajos, etc.), y
// validado también del lado del backend (backend/src/routes/services.js).
const DESCRIPCION_MAX = 600

interface RawTicket {
  id: string
  folio: string
  student_id: string
  tipo: string
  descripcion: string | null
  categoria: 'Trámite escolar' | 'Soporte / Incidencia'
  fecha: string
  status: string
}

interface Props {
  role?: Role
  studentId?: string | null
}

export default function Servicios({ role, studentId }: Props) {
  const isAdmin = role === 'Administrador' || role === 'Control Escolar'
  const isAlumno = role === 'Alumno'
  // Vinculación también puede procesar trámites/tickets (cambiar su status),
  // aunque el encabezado siga mostrando el texto de "consulta" reservado a Admin/Control Escolar.
  const canManage = isAdmin || role === 'Vinculacion'

  return isAlumno ? <AlumnoServicios studentId={studentId ?? null} /> : <StaffServicios isAdmin={isAdmin} canManage={canManage} />
}

const STATUS_OPTIONS: Record<RawTicket['categoria'], string[]> = {
  'Trámite escolar': ['En proceso', 'Listo para recoger', 'Entregado', 'Rechazado'],
  'Soporte / Incidencia': ['Abierto', 'En proceso', 'Resuelto'],
}

// ---------------------------------------------------------------------------
// Vista de Administración / Control Escolar / Vinculación: consulta y,
// para quien puede gestionar (canManage), cambio de status de cada solicitud.
// ---------------------------------------------------------------------------
function StaffServicios({ isAdmin, canManage }: { isAdmin: boolean; canManage: boolean }) {
  const [tab, setTab] = useState<'tramites' | 'soporte'>('tramites')
  const [tickets, setLocalTickets] = useState<typeof TICKETS>(TICKETS)
  const [loading, setLoading] = useState(true)
  const [savingId, setSavingId] = useState<string | null>(null)
  const { msg, show, fire } = useToast()

  useEffect(() => {
    serviceTicketService
      .getAll()
      .then((data) => {
        const list = data as RawTicket[]
        const withNames = list.map((t) => ({ ...t, solicitante: TICKETS.find((old) => old.id === t.id)?.solicitante ?? t.student_id }))
        setLocalTickets(withNames)
        setTickets(withNames)
      })
      .catch(() => setLocalTickets(TICKETS))
      .finally(() => setLoading(false))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const rows = tickets.filter((t) => (tab === 'tramites' ? t.categoria === 'Trámite escolar' : t.categoria === 'Soporte / Incidencia'))

  const changeStatus = async (ticket: (typeof TICKETS)[number], status: string) => {
    setSavingId(ticket.id)
    try {
      await serviceTicketService.update(ticket.id, { status })
      const updated = tickets.map((t) => (t.id === ticket.id ? { ...t, status } : t))
      setLocalTickets(updated)
      setTickets(updated)
      fire(`Folio ${ticket.folio} → ${status}`)
    } catch (err) {
      fire(err instanceof ApiError ? err.message : 'No se pudo actualizar el status.')
    } finally {
      setSavingId(null)
    }
  }

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div>
        <h1 style={{ fontSize: 22, margin: 0 }}>{isAdmin ? 'Servicios consultados' : 'Servicios'}</h1>
        <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>
          {isAdmin ? 'Quién y cuándo solicitó cada trámite o servicio.' : 'Trámites escolares, solicitudes, tickets e incidencias.'}
        </p>
      </div>

      <Card>
        <Tabs
          tabs={[
            { id: 'tramites', label: 'Trámites escolares' },
            { id: 'soporte', label: 'Soporte / Incidencias' },
          ]}
          active={tab}
          onChange={(id) => setTab(id as 'tramites' | 'soporte')}
        />
        {loading ? (
          <p style={{ fontSize: 13, color: 'var(--muted-foreground)', padding: '18px 4px' }}>Cargando…</p>
        ) : rows.length === 0 ? (
          <EmptyState title="Sin solicitudes" subtitle="No hay registros en esta categoría por ahora." />
        ) : (
          <Table headers={['Folio', 'Solicitante', 'Tipo', 'Fecha', 'Status']}>
            {rows.map((t) => (
              <tr key={t.id} style={{ borderBottom: '1px solid var(--border)' }}>
                <td style={{ padding: '10px 12px', fontFamily: 'monospace', fontSize: 12 }}>{t.folio}</td>
                <td style={{ padding: '10px 12px', fontWeight: 500 }}>{t.solicitante}</td>
                <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>
                  {t.tipo}
                  {t.descripcion && (
                    <div style={{ fontSize: 11.5, color: 'var(--muted-foreground)', marginTop: 3, maxWidth: 320 }}>{t.descripcion}</div>
                  )}
                </td>
                <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{t.fecha}</td>
                <td style={{ padding: '10px 12px' }}>
                  {canManage ? (
                    <select
                      value={t.status}
                      disabled={savingId === t.id}
                      onChange={(e) => changeStatus(t, e.target.value)}
                      style={{
                        padding: '5px 8px',
                        borderRadius: 6,
                        border: '1px solid var(--border)',
                        fontSize: 12,
                        fontWeight: 700,
                        color: STATUS_STYLE[t.status]?.color ?? 'var(--foreground)',
                        background: STATUS_STYLE[t.status]?.bg ?? '#fff',
                      }}
                    >
                      {STATUS_OPTIONS[t.categoria].map((s) => (
                        <option key={s} value={s}>
                          {s}
                        </option>
                      ))}
                    </select>
                  ) : (
                    <Badge text={t.status} bg={STATUS_STYLE[t.status].bg} color={STATUS_STYLE[t.status].color} />
                  )}
                </td>
              </tr>
            ))}
          </Table>
        )}
      </Card>

      <Toast message={msg} show={show} />
    </div>
  )
}

// ---------------------------------------------------------------------------
// Vista del Alumno: solicitar constancia o reportar un problema + historial
// ---------------------------------------------------------------------------
type Opcion = 'constancia' | 'problema'

function AlumnoServicios({ studentId }: { studentId: string | null }) {
  const [tickets, setTickets] = useState<RawTicket[]>([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState('')

  const [opcion, setOpcion] = useState<Opcion>('constancia')
  const [descripcion, setDescripcion] = useState('')
  const [sending, setSending] = useState(false)
  const [formErr, setFormErr] = useState('')

  const { msg, show, fire } = useToast()

  async function loadMisSolicitudes() {
    if (!studentId) return
    setLoading(true)
    setLoadError('')
    try {
      const data = (await serviceTicketService.forStudent(studentId)) as RawTicket[]
      setTickets(data)
    } catch (err) {
      setLoadError(err instanceof ApiError ? err.message : 'No se pudo cargar tu historial de solicitudes.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadMisSolicitudes()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [studentId])

  function handleOpcionChange(next: Opcion) {
    setOpcion(next)
    setFormErr('')
    if (next === 'constancia') setDescripcion('')
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!studentId) {
      fire('Tu usuario no tiene un expediente de alumno asociado.')
      return
    }
    if (opcion === 'problema' && !descripcion.trim()) {
      setFormErr('Cuéntanos brevemente qué problema tienes para poder atenderlo.')
      return
    }
    setFormErr('')
    setSending(true)
    try {
      const created = (await serviceTicketService.create({
        student_id: studentId,
        tipo: opcion === 'constancia' ? 'Constancia de estudios' : 'Reportar problema',
        descripcion: opcion === 'problema' ? descripcion.trim() : undefined,
        categoria: opcion === 'constancia' ? 'Trámite escolar' : 'Soporte / Incidencia',
        fecha: new Date().toISOString().slice(0, 10),
      })) as RawTicket
      fire(`Solicitud enviada · Folio ${created.folio}`)
      setDescripcion('')
      await loadMisSolicitudes()
    } catch (err) {
      fire(err instanceof ApiError ? err.message : 'No se pudo enviar la solicitud')
    } finally {
      setSending(false)
    }
  }

  const remaining = DESCRIPCION_MAX - descripcion.length

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div>
        <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>
          Solicita tu constancia de estudios o reporta un problema. Aquí puedes ver el estatus de tus solicitudes.
        </p>
      </div>

      <Card>
        <h3 style={{ margin: '0 0 4px', fontSize: 15 }}>Solicitar servicio</h3>
        <p style={{ color: 'var(--muted-foreground)', fontSize: 12.5, margin: '0 0 18px' }}>
          Tu solicitud llegará directamente a Control Escolar.
        </p>

        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
          <div style={{ display: 'flex', gap: 8 }}>
            {([
              {
                id: 'constancia' as const,
                icon: 'file' as const,
                title: 'Constancia de estudios',
                subtitle: 'Documento oficial de inscripción vigente.',
              },
              {
                id: 'problema' as const,
                icon: 'wrench' as const,
                title: 'Reportar problema',
                subtitle: 'Escolar, con un docente, o del sistema/portal.',
              },
            ]).map((op) => (
              <button
                key={op.id}
                type="button"
                onClick={() => handleOpcionChange(op.id)}
                style={{
                  flex: 1,
                  display: 'flex',
                  alignItems: 'flex-start',
                  gap: 10,
                  padding: '12px 16px',
                  borderRadius: 10,
                  border: opcion === op.id ? '1px solid var(--primary)' : '1px solid var(--border)',
                  background: opcion === op.id ? 'var(--secondary)' : '#fff',
                  color: 'var(--foreground)',
                  cursor: 'pointer',
                  textAlign: 'left',
                }}
              >
                <Icon name={op.icon} size={18} style={{ color: 'var(--primary-dark)', marginTop: 2, flexShrink: 0 }} />
                <div>
                  <div style={{ fontSize: 13, fontWeight: 700 }}>{op.title}</div>
                  <div style={{ fontSize: 11, fontWeight: 400, color: 'var(--muted-foreground)', marginTop: 3 }}>{op.subtitle}</div>
                </div>
              </button>
            ))}
          </div>

          {opcion === 'problema' && (
            <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 12.5, fontWeight: 600, color: 'var(--muted-foreground)' }}>
              Describe tu problema
              <textarea
                value={descripcion}
                onChange={(e) => setDescripcion(e.target.value.slice(0, DESCRIPCION_MAX))}
                maxLength={DESCRIPCION_MAX}
                rows={4}
                placeholder="Cuéntanos qué pasó: por ejemplo, un problema con una materia, con un docente, o al usar el portal…"
                style={{ padding: '10px 12px', borderRadius: 8, border: '1px solid var(--border)', fontSize: 13.5, fontFamily: 'inherit', resize: 'vertical', color: 'var(--foreground)' }}
              />
              <span style={{ fontSize: 11, alignSelf: 'flex-end', color: remaining <= 30 ? '#c2410c' : 'var(--muted-foreground)' }}>
                {remaining} caracteres restantes
              </span>
            </label>
          )}

          {formErr && <span style={{ fontSize: 12, color: '#b42318' }}>{formErr}</span>}

          <div>
            <Button variant="primary" type="submit">
              {sending ? 'Enviando…' : 'Enviar solicitud'}
            </Button>
          </div>
        </form>
      </Card>

      <Card>
        <h3 style={{ margin: '0 0 14px', fontSize: 15 }}>
          Mis solicitudes{tickets.length > 0 && <span style={{ color: 'var(--muted-foreground)', fontWeight: 400 }}> · {tickets.length}</span>}
        </h3>

        {loadError && (
          <div style={{ padding: '10px 14px', borderRadius: 10, background: '#fdeeee', color: '#b42318', fontSize: 12.5, marginBottom: 14 }}>
            {loadError}
          </div>
        )}

        {loading ? (
          <p style={{ fontSize: 13, color: 'var(--muted-foreground)' }}>Cargando…</p>
        ) : tickets.length === 0 ? (
          <EmptyState title="Aún no has hecho solicitudes" subtitle="Cuando envíes un trámite o reportes un problema, aparecerá aquí." />
        ) : (
          <Table headers={['Folio', 'Tipo', 'Fecha', 'Status']}>
            {tickets.map((t) => (
              <tr key={t.id} style={{ borderBottom: '1px solid var(--border)' }}>
                <td style={{ padding: '10px 12px', fontFamily: 'monospace', fontSize: 12 }}>{t.folio}</td>
                <td style={{ padding: '10px 12px', fontWeight: 500 }}>
                  {t.tipo}
                  {t.descripcion && (
                    <div style={{ fontSize: 11.5, fontWeight: 400, color: 'var(--muted-foreground)', marginTop: 3, maxWidth: 380 }}>{t.descripcion}</div>
                  )}
                </td>
                <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{t.fecha}</td>
                <td style={{ padding: '10px 12px' }}>
                  <Badge text={t.status} bg={STATUS_STYLE[t.status].bg} color={STATUS_STYLE[t.status].color} />
                </td>
              </tr>
            ))}
          </Table>
        )}
      </Card>

      <Toast message={msg} show={show} />
    </div>
  )
}