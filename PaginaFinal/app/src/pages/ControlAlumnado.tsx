import { useEffect, useMemo, useState } from 'react'
import { ALUMNOS, GRUPOS, type Alumno } from '../data/alumnos'
import { Card, StatCard, Badge, Button, Input, Table, Tabs, Modal, Select, Toast, useToast } from '../components/ui'
import { Icon, type IconName } from '../components/Icon'
import { studentService, loadAppData } from '../services'
import { api, ApiError } from '../services/api'
import type { Role } from '../types'

const STATUS_STYLE: Record<Alumno['status'], { bg: string; color: string }> = {
  Activo: { bg: '#f0faf4', color: '#15803d' },
  'Baja temporal': { bg: '#fff7ed', color: '#c2410c' },
  Egresado: { bg: '#eff6ff', color: '#1d4ed8' },
}

const STATUS_OPTIONS: Alumno['status'][] = ['Activo', 'Baja temporal', 'Egresado']

function IconLabel({ icon, color, children }: { icon: IconName; color?: string; children: React.ReactNode }) {
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 6, color }}>
      <Icon name={icon} size={14} style={{ flexShrink: 0 }} />
      {children}
    </span>
  )
}

interface RawGroup {
  id: string
  nombre: string
  career_id: string
  cuatrimestre: string
  periodo: string
  aula: string
  turno: string
}

interface Props {
  initialGrupo?: string
  role?: Role
}

export default function ControlAlumnado({ initialGrupo, role }: Props) {
  const isAdmin = role === 'Administrador'

  const [query, setQuery] = useState('')
  const [grupoFilter, setGrupoFilter] = useState<string>(initialGrupo ?? 'Todos')
  const [selected, setSelected] = useState<Alumno | null>(null)
  const [tick, setTick] = useState(0) // fuerza re-render tras alta/baja/edición (ALUMNOS se muta en el mismo arreglo)

  const [rawGroups, setRawGroups] = useState<RawGroup[]>([])
  const [formOpen, setFormOpen] = useState(false)
  const [editing, setEditing] = useState<Alumno | null>(null)
  const [busy, setBusy] = useState(false)

  const { msg, show, fire } = useToast()

  // Solo el admin necesita el catálogo crudo de grupos (con career_id) para el formulario
  useEffect(() => {
    if (!isAdmin) return
    api.get<RawGroup[]>('/groups').then(setRawGroups).catch(() => {})
  }, [isAdmin])

  const filtered = useMemo(() => {
    return ALUMNOS.filter((a) => {
      const matchesGroup = grupoFilter === 'Todos' || a.grupo === grupoFilter
      const matchesQuery =
        query.trim() === '' ||
        a.nombre.toLowerCase().includes(query.toLowerCase()) ||
        a.expediente.includes(query)
      return matchesGroup && matchesQuery
    })
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [query, grupoFilter, tick])

  const counts = GRUPOS.map((g) => ({ grupo: g, total: ALUMNOS.filter((a) => a.grupo === g).length }))

  async function refresh() {
    await loadAppData()
    setTick((t) => t + 1)
  }

  function openCreate() {
    setEditing(null)
    setFormOpen(true)
  }

  function openEdit(a: Alumno) {
    setEditing(a)
    setFormOpen(true)
  }

  async function handleSubmit(payload: Record<string, unknown>) {
    setBusy(true)
    try {
      if (editing) {
        await studentService.update(editing.id, payload)
        fire('Alumno actualizado correctamente')
      } else {
        await studentService.create(payload)
        fire('Alumno dado de alta correctamente')
      }
      const editedId = editing?.id
      await refresh()
      setFormOpen(false)
      setEditing(null)
      if (selected && editedId && selected.id === editedId) {
        setSelected(ALUMNOS.find((s) => s.id === editedId) || null)
      }
    } catch (err) {
      fire(err instanceof ApiError ? err.message : 'Ocurrió un error al guardar el alumno')
    } finally {
      setBusy(false)
    }
  }

  async function handleToggleStatus(a: Alumno) {
    const nextStatus: Alumno['status'] = a.status === 'Activo' ? 'Baja temporal' : 'Activo'
    setBusy(true)
    try {
      await studentService.update(a.id, { status: nextStatus })
      await refresh()
      fire(nextStatus === 'Baja temporal' ? 'Alumno dado de baja' : 'Alumno reactivado')
      if (selected?.id === a.id) setSelected({ ...a, status: nextStatus })
    } catch (err) {
      fire(err instanceof ApiError ? err.message : 'No se pudo cambiar el status')
    } finally {
      setBusy(false)
    }
  }

  async function handleDelete(a: Alumno) {
    if (
      !window.confirm(
        `¿Eliminar definitivamente a ${a.nombre}?\n\nEsta acción borrará también sus calificaciones, asistencia e inscripciones. No se puede deshacer.`
      )
    ) {
      return
    }
    setBusy(true)
    try {
      await studentService.remove(a.id)
      await refresh()
      fire('Alumno eliminado')
      if (selected?.id === a.id) setSelected(null)
    } catch (err) {
      fire(err instanceof ApiError ? err.message : 'No se pudo eliminar al alumno')
    } finally {
      setBusy(false)
    }
  }

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))', gap: 14 }}>
        <StatCard label="Alumnos totales" value={ALUMNOS.length} icon="◍" tint="var(--secondary)" />
        {counts.map((c) => (
          <StatCard key={c.grupo} label={c.grupo} value={c.total} icon="▥" tint="var(--gold-light)" />
        ))}
      </div>

      <Card>
        <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap', alignItems: 'center' }}>
          <Input value={query} onChange={setQuery} placeholder="Buscar por nombre o expediente…" style={{ minWidth: 260 }} />
          <div style={{ display: 'flex', gap: 6 }}>
            {['Todos', ...GRUPOS].map((g) => (
              <button
                key={g}
                onClick={() => setGrupoFilter(g)}
                style={{
                  padding: '7px 13px',
                  borderRadius: 7,
                  fontSize: 12.5,
                  fontWeight: 600,
                  border: '1px solid var(--border)',
                  background: grupoFilter === g ? 'var(--primary)' : '#fff',
                  color: grupoFilter === g ? '#fff' : 'var(--foreground)',
                  cursor: 'pointer',
                }}
              >
                {g}
              </button>
            ))}
          </div>
          <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 14 }}>
            <span style={{ fontSize: 12.5, color: 'var(--muted-foreground)' }}>
              {filtered.length} de {ALUMNOS.length} alumnos
            </span>
            {isAdmin && (
              <Button variant="primary" small onClick={openCreate}>
                <IconLabel icon="userPlus">Nuevo alumno</IconLabel>
              </Button>
            )}
          </div>
        </div>

        <Table headers={['No.', 'Expediente', 'Nombre', 'Grupo', 'Status', '']}>
          {filtered.map((a) => (
            <tr key={a.id} style={{ borderBottom: '1px solid var(--border)' }}>
              <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{a.no}</td>
              <td style={{ padding: '10px 12px', fontFamily: 'monospace', fontSize: 12.5 }}>{a.expediente}</td>
              <td style={{ padding: '10px 12px', fontWeight: 500 }}>{a.nombre}</td>
              <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{a.grupo}</td>
              <td style={{ padding: '10px 12px' }}>
                <Badge text={a.status} bg={STATUS_STYLE[a.status].bg} color={STATUS_STYLE[a.status].color} />
              </td>
              <td style={{ padding: '10px 12px', textAlign: 'right', whiteSpace: 'nowrap' }}>
                <Button variant="ghost" small onClick={() => setSelected(a)}>
                  <IconLabel icon="eye">Ver expediente</IconLabel>
                </Button>
                {isAdmin && (
                  <>
                    {' '}
                    <Button variant="ghost" small onClick={() => openEdit(a)}>
                      <IconLabel icon="edit">Editar</IconLabel>
                    </Button>{' '}
                    <Button variant="ghost" small onClick={() => handleToggleStatus(a)}>
                      <IconLabel icon={a.status === 'Activo' ? 'userX' : 'userCheck'}>
                        {a.status === 'Activo' ? 'Dar de baja' : 'Reactivar'}
                      </IconLabel>
                    </Button>{' '}
                    <Button variant="ghost" small onClick={() => handleDelete(a)}>
                      <IconLabel icon="trash" color="#a33b3b">
                        Eliminar
                      </IconLabel>
                    </Button>
                  </>
                )}
              </td>
            </tr>
          ))}
        </Table>
      </Card>

      {selected && (
        <AlumnoDrawer
          alumno={selected}
          isAdmin={isAdmin}
          onClose={() => setSelected(null)}
          onEdit={() => openEdit(selected)}
          onToggleStatus={() => handleToggleStatus(selected)}
          onDelete={() => handleDelete(selected)}
        />
      )}

      {formOpen && (
        <StudentFormModal
          initial={editing}
          groups={rawGroups}
          busy={busy}
          onClose={() => {
            setFormOpen(false)
            setEditing(null)
          }}
          onSubmit={handleSubmit}
        />
      )}

      <Toast message={msg} show={show} />
    </div>
  )
}

function AlumnoDrawer({
  alumno,
  isAdmin,
  onClose,
  onEdit,
  onToggleStatus,
  onDelete,
}: {
  alumno: Alumno
  isAdmin: boolean
  onClose: () => void
  onEdit: () => void
  onToggleStatus: () => void
  onDelete: () => void
}) {
  const [tab, setTab] = useState('resumen')
  return (
    <div
      style={{
        position: 'fixed',
        inset: 0,
        background: 'rgba(15,23,42,0.4)',
        display: 'flex',
        justifyContent: 'flex-end',
        zIndex: 50,
      }}
      onClick={onClose}
    >
      <div
        onClick={(e) => e.stopPropagation()}
        style={{ width: 460, maxWidth: '92vw', background: '#fff', height: '100%', overflowY: 'auto', padding: 24 }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 18 }}>
          <div>
            <div style={{ fontSize: 16, fontWeight: 700 }}>{alumno.nombre}</div>
            <div style={{ fontSize: 12.5, color: 'var(--muted-foreground)' }}>
              Exp. {alumno.expediente} · {alumno.grupo}
            </div>
          </div>
          <Button variant="secondary" small onClick={onClose}>
            Cerrar
          </Button>
        </div>

        {isAdmin && (
          <div style={{ display: 'flex', gap: 8, marginBottom: 18, flexWrap: 'wrap' }}>
            <Button variant="secondary" small onClick={onEdit}>
              <IconLabel icon="edit">Editar</IconLabel>
            </Button>
            <Button variant="secondary" small onClick={onToggleStatus}>
              <IconLabel icon={alumno.status === 'Activo' ? 'userX' : 'userCheck'}>
                {alumno.status === 'Activo' ? 'Dar de baja' : 'Reactivar'}
              </IconLabel>
            </Button>
            <Button variant="ghost" small onClick={onDelete}>
              <IconLabel icon="trash" color="#a33b3b">
                Eliminar
              </IconLabel>
            </Button>
          </div>
        )}

        <Tabs
          tabs={[
            { id: 'resumen', label: 'Resumen' },
            { id: 'academico', label: 'Académico' },
            { id: 'contacto', label: 'Contacto' },
          ]}
          active={tab}
          onChange={setTab}
        />

        {tab === 'resumen' && (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            <InfoRow label="No. de lista" value={String(alumno.no)} />
            <InfoRow label="Expediente" value={alumno.expediente} />
            <InfoRow label="Grupo" value={alumno.grupo} />
            <InfoRow label="Carrera" value={alumno.carrera} />
            <InfoRow label="Cuatrimestre" value={alumno.cuatrimestre} />
            <InfoRow label="Status" value={alumno.status} />
          </div>
        )}

        {tab === 'academico' && (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            <InfoRow label="Promedio" value={String(alumno.promedio)} />
            <InfoRow label="Asistencia" value={`${alumno.asistencia}%`} />
            <InfoRow label="Kardex" value="Consultar en Procesos Digitales → Kardex" />
          </div>
        )}

        {tab === 'contacto' && (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            <InfoRow label="Correo institucional" value={alumno.email || 'No capturado'} />
            <InfoRow label="Teléfono" value="No capturado" />
          </div>
        )}
      </div>
    </div>
  )
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, padding: '8px 0', borderBottom: '1px solid var(--border)' }}>
      <span style={{ color: 'var(--muted-foreground)' }}>{label}</span>
      <span style={{ fontWeight: 500, textAlign: 'right' }}>{value}</span>
    </div>
  )
}

function StudentFormModal({
  initial,
  groups,
  busy,
  onClose,
  onSubmit,
}: {
  initial: Alumno | null
  groups: RawGroup[]
  busy: boolean
  onClose: () => void
  onSubmit: (payload: Record<string, unknown>) => void
}) {
  const [nombre, setNombre] = useState(initial?.nombre ?? '')
  const [expediente, setExpediente] = useState(initial?.expediente ?? '')
  const [groupId, setGroupId] = useState(initial?.grupo ?? groups[0]?.id ?? '')
  const [email, setEmail] = useState(initial?.email ?? '')
  const [status, setStatus] = useState<Alumno['status']>(initial?.status ?? 'Activo')
  const [no, setNo] = useState(initial ? String(initial.no) : '')

  const canSubmit = nombre.trim() !== '' && groupId !== '' && groups.length > 0

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!canSubmit || busy) return
    const selectedGroup = groups.find((g) => g.id === groupId)
    onSubmit({
      nombre: nombre.trim(),
      expediente: expediente.trim(),
      group_id: groupId,
      email: email.trim() || undefined,
      status,
      no: no ? Number(no) : undefined,
      career_id: selectedGroup?.career_id,
      cuatrimestre: selectedGroup?.cuatrimestre,
      periodo: selectedGroup?.periodo,
    })
  }

  return (
    <Modal title={initial ? 'Editar alumno' : 'Nuevo alumno'} onClose={onClose} width={480}>
      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
        <Field label="Nombre completo *">
          <Input value={nombre} onChange={setNombre} placeholder="APELLIDO APELLIDO NOMBRE(S)" style={{ width: '100%' }} />
        </Field>

        <div className="rg-2" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
          <Field label="Expediente">
            <Input value={expediente} onChange={setExpediente} placeholder="23304059" style={{ width: '100%' }} />
          </Field>
          <Field label="No. de lista">
            <Input value={no} onChange={setNo} placeholder="Automático si se deja vacío" style={{ width: '100%' }} />
          </Field>
        </div>

        <Field label="Grupo *">
          {groups.length ? (
            <Select value={groupId} onChange={setGroupId} options={groups.map((g) => g.id)} style={{ width: '100%' }} />
          ) : (
            <span style={{ fontSize: 12.5, color: '#c2410c' }}>No se pudieron cargar los grupos. Verifica la conexión con el backend.</span>
          )}
        </Field>

        <div className="rg-2" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
          <Field label="Correo institucional">
            <Input value={email} onChange={setEmail} placeholder="alumno@utslrc.edu.mx" style={{ width: '100%' }} />
          </Field>
          <Field label="Status">
            <Select value={status} onChange={(v) => setStatus(v as Alumno['status'])} options={STATUS_OPTIONS} style={{ width: '100%' }} />
          </Field>
        </div>

        {!initial && (
          <p style={{ fontSize: 12, color: 'var(--muted-foreground)', margin: 0 }}>
            El ID de alumno (AL0##) se genera automáticamente al guardar.
          </p>
        )}

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10, marginTop: 4 }}>
          <Button variant="secondary" onClick={onClose}>
            Cancelar
          </Button>
          <Button variant="primary" type="submit">
            <IconLabel icon={initial ? 'check' : 'userPlus'}>{busy ? 'Guardando…' : initial ? 'Guardar cambios' : 'Dar de alta'}</IconLabel>
          </Button>
        </div>
      </form>
    </Modal>
  )
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 12.5, fontWeight: 600, color: 'var(--muted-foreground)' }}>
      {label}
      {children}
    </label>
  )
}