import { useEffect, useState } from 'react'
import { TEACHERS, type Teacher } from '../data/teachers'
import { Card, Badge, Button, Modal, Input, Toast, useToast } from '../components/ui'
import { teacherService, loadAppData } from '../services'
import { api, ApiError } from '../services/api'
import type { Role } from '../types'

interface RawGroup {
  id: string
  nombre: string
  career_id: string
  cuatrimestre: string
  periodo: string
}

interface Props {
  role?: Role
}

export default function Docentes({ role }: Props) {
  const isAdmin = role === 'Administrador'

  const [tick, setTick] = useState(0)
  const [rawGroups, setRawGroups] = useState<RawGroup[]>([])
  const [formOpen, setFormOpen] = useState(false)
  const [editing, setEditing] = useState<Teacher | null>(null)
  const [selected, setSelected] = useState<Teacher | null>(null)
  const [busy, setBusy] = useState(false)
  const { msg, show, fire } = useToast()

  useEffect(() => {
    if (!isAdmin) return
    api.get<RawGroup[]>('/groups').then(setRawGroups).catch(() => {})
  }, [isAdmin])

  async function refresh() {
    await loadAppData()
    setTick((t) => t + 1)
  }

  function openCreate() {
    setEditing(null)
    setFormOpen(true)
  }

  function openEdit(t: Teacher) {
    setEditing(t)
    setFormOpen(true)
  }

  async function handleSubmit(payload: Record<string, unknown>) {
    setBusy(true)
    try {
      if (editing) {
        await teacherService.update(editing.id, payload)
        fire('Docente actualizado correctamente')
      } else {
        await teacherService.create(payload)
        fire('Docente dado de alta correctamente')
      }
      await refresh()
      setFormOpen(false)
      setEditing(null)
      setSelected(null)
    } catch (err) {
      fire(err instanceof ApiError ? err.message : 'Ocurrió un error al guardar el docente')
    } finally {
      setBusy(false)
    }
  }

  async function handleDelete(t: Teacher) {
    if (
      !window.confirm(
        `¿Eliminar definitivamente a ${t.nombre}?\n\nSus materias quedarán sin docente asignado. No se puede deshacer.`
      )
    ) {
      return
    }
    setBusy(true)
    try {
      await teacherService.remove(t.id)
      await refresh()
      fire('Docente eliminado')
      setSelected(null)
    } catch (err) {
      fire(err instanceof ApiError ? err.message : 'No se pudo eliminar al docente')
    } finally {
      setBusy(false)
    }
  }

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <div>
          <h1 style={{ fontSize: 22, margin: 0 }}>Docentes</h1>
          <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>Directorio académico y carga de grupos.</p>
        </div>
        {isAdmin && (
          <Button variant="primary" small onClick={openCreate}>
            + Nuevo docente
          </Button>
        )}
      </div>
      <Card style={{ padding: 0, overflow: 'hidden' }}>
        {TEACHERS.map((t, i) => (
          <div
            key={t.id}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 16,
              padding: '14px 18px',
              borderBottom: i === TEACHERS.length - 1 ? 'none' : '1px solid var(--border)',
              flexWrap: 'wrap',
            }}
          >
            <div
              style={{
                width: 46,
                height: 46,
                borderRadius: '50%',
                background: 'linear-gradient(135deg,var(--primary),var(--navy))',
                color: '#fff',
                display: 'grid',
                placeItems: 'center',
                fontWeight: 800,
                fontSize: 14,
                flexShrink: 0,
              }}
            >
              {t.nombre.split(' ').map((w) => w[0]).slice(0, 2).join('')}
            </div>

            <div style={{ minWidth: 170, flex: '1 1 200px' }}>
              <div style={{ fontWeight: 600, fontSize: 13.5 }}>{t.nombre}</div>
              <div style={{ fontSize: 11.5, color: 'var(--muted-foreground)' }}>{t.grado || 'Docente'}</div>
            </div>

            <div style={{ minWidth: 140, flex: '1 1 160px', fontSize: 12, color: 'var(--muted-foreground)' }}>
              {t.email || 'Sin correo capturado'}
            </div>

            <div style={{ display: 'flex', gap: 8, flexShrink: 0 }}>
              <Badge text={`${t.grupos.length} ${t.grupos.length === 1 ? 'grupo' : 'grupos'}`} bg="var(--secondary)" color="var(--secondary-foreground)" />
              <Badge text={`${t.materias.length} ${t.materias.length === 1 ? 'materia' : 'materias'}`} bg="var(--gold-light)" color="#92650f" />
            </div>

            <div style={{ display: 'flex', gap: 8, flexShrink: 0, marginLeft: 'auto' }}>
              <Button variant="secondary" small onClick={() => setSelected(t)}>
                Ver perfil
              </Button>
              {isAdmin && (
                <>
                  <Button variant="secondary" small onClick={() => openEdit(t)}>
                    Editar
                  </Button>
                  <Button variant="ghost" small onClick={() => handleDelete(t)}>
                    Eliminar
                  </Button>
                </>
              )}
            </div>
          </div>
        ))}
        {!TEACHERS.length && (
          <p style={{ padding: '18px 12px', textAlign: 'center', color: 'var(--muted-foreground)', fontSize: 13, margin: 0 }}>
            No hay docentes registrados todavía.
          </p>
        )}
      </Card>

      {selected && <TeacherProfile teacher={selected} onClose={() => setSelected(null)} />}

      {formOpen && (
        <TeacherFormModal
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

function TeacherProfile({ teacher, onClose }: { teacher: Teacher; onClose: () => void }) {
  return (
    <Modal title={teacher.nombre} onClose={onClose} width={440}>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
        <InfoRow label="Grado" value={teacher.grado || 'No capturado'} />
        <InfoRow label="Correo" value={teacher.email || 'No capturado'} />
        <InfoRow label="Grupos a cargo" value={teacher.grupos.length ? teacher.grupos.join(', ') : 'Sin grupos asignados'} />
        <InfoRow label="Materias" value={teacher.materias.length ? teacher.materias.join(', ') : 'Sin materias asignadas'} />
      </div>
    </Modal>
  )
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, fontSize: 13, padding: '8px 0', borderBottom: '1px solid var(--border)' }}>
      <span style={{ color: 'var(--muted-foreground)', flexShrink: 0 }}>{label}</span>
      <span style={{ fontWeight: 500, textAlign: 'right' }}>{value}</span>
    </div>
  )
}

function TeacherFormModal({
  initial,
  groups,
  busy,
  onClose,
  onSubmit,
}: {
  initial: Teacher | null
  groups: RawGroup[]
  busy: boolean
  onClose: () => void
  onSubmit: (payload: Record<string, unknown>) => void
}) {
  const [nombre, setNombre] = useState(initial?.nombre ?? '')
  const [grado, setGrado] = useState(initial?.grado ?? '')
  const [email, setEmail] = useState(initial?.email ?? '')
  const [grupos, setGrupos] = useState<string[]>(initial?.grupos ?? [])

  const canSubmit = nombre.trim() !== ''

  function toggleGrupo(id: string) {
    setGrupos((prev) => (prev.includes(id) ? prev.filter((g) => g !== id) : [...prev, id]))
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!canSubmit || busy) return
    onSubmit({
      nombre: nombre.trim(),
      grado: grado.trim() || undefined,
      email: email.trim() || undefined,
      grupos,
    })
  }

  return (
    <Modal title={initial ? 'Editar docente' : 'Nuevo docente'} onClose={onClose} width={480}>
      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
        <Field label="Nombre completo *">
          <Input value={nombre} onChange={setNombre} placeholder="Ing. Nombre Apellido Apellido" style={{ width: '100%' }} />
        </Field>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
          <Field label="Grado académico">
            <Input value={grado} onChange={setGrado} placeholder="Maestría en TI" style={{ width: '100%' }} />
          </Field>
          <Field label="Correo institucional">
            <Input value={email} onChange={setEmail} placeholder="docente@utslrc.edu.mx" style={{ width: '100%' }} />
          </Field>
        </div>

        <Field label="Grupos a cargo">
          {groups.length ? (
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginTop: 2 }}>
              {groups.map((g) => (
                <label
                  key={g.id}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: 6,
                    padding: '6px 10px',
                    borderRadius: 7,
                    border: '1px solid var(--border)',
                    background: grupos.includes(g.id) ? 'var(--secondary)' : '#fff',
                    fontSize: 12.5,
                    fontWeight: 500,
                    color: 'var(--foreground)',
                    cursor: 'pointer',
                  }}
                >
                  <input type="checkbox" checked={grupos.includes(g.id)} onChange={() => toggleGrupo(g.id)} />
                  {g.id}
                </label>
              ))}
            </div>
          ) : (
            <span style={{ fontSize: 12.5, color: '#c2410c' }}>No se pudieron cargar los grupos.</span>
          )}
        </Field>

        {!initial && (
          <p style={{ fontSize: 12, color: 'var(--muted-foreground)', margin: 0 }}>
            El ID de docente (DOC0##) se genera automáticamente al guardar.
          </p>
        )}

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10, marginTop: 4 }}>
          <Button variant="secondary" onClick={onClose}>
            Cancelar
          </Button>
          <Button variant="primary" type="submit">
            {busy ? 'Guardando…' : initial ? 'Guardar cambios' : 'Dar de alta'}
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