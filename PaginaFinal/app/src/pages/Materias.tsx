import { useEffect, useMemo, useState } from 'react'
import { SUBJECTS } from '../data/academic'
import { Card, Badge, Button, Input, Modal, Select, Toast, useToast } from '../components/ui'
import { subjectService, loadAppData } from '../services'
import { api, ApiError } from '../services/api'

interface RawGroup {
  id: string
  nombre: string
  career_id: string
  cuatrimestre: string
  periodo: string
  aula: string
  turno: string
}

interface RawTeacher {
  id: string
  nombre: string
}

export default function Materias() {
  const [tick, setTick] = useState(0)
  const [query, setQuery] = useState('')
  const [groups, setGroups] = useState<RawGroup[]>([])
  const [teachers, setTeachers] = useState<RawTeacher[]>([])
  const [formOpen, setFormOpen] = useState(false)
  const [busy, setBusy] = useState(false)
  const { msg, show, fire } = useToast()

  useEffect(() => {
    api.get<RawGroup[]>('/groups').then(setGroups).catch(() => {})
    api.get<RawTeacher[]>('/teachers').then(setTeachers).catch(() => {})
  }, [])

  const filtered = useMemo(
    () =>
      SUBJECTS.filter(
        (s) =>
          query.trim() === '' ||
          s.nombre.toLowerCase().includes(query.toLowerCase()) ||
          s.grupo.toLowerCase().includes(query.toLowerCase()) ||
          s.id.toLowerCase().includes(query.toLowerCase())
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [query, tick]
  )

  // Agrupa las materias filtradas por grupo, respetando el orden en que
  // aparecen los grupos en /groups cuando ya cargaron; si no, usa el orden
  // de aparición dentro de las materias mismas.
  const groupedByGrupo = useMemo(() => {
    const order = groups.length ? groups.map((g) => g.id) : []
    const map = new Map<string, typeof filtered>()
    for (const s of filtered) {
      const list = map.get(s.grupo)
      if (list) list.push(s)
      else map.set(s.grupo, [s])
    }
    const keys = Array.from(map.keys()).sort((a, b) => {
      const ia = order.indexOf(a)
      const ib = order.indexOf(b)
      if (ia === -1 && ib === -1) return a.localeCompare(b)
      if (ia === -1) return 1
      if (ib === -1) return -1
      return ia - ib
    })
    return keys.map((grupo) => ({ grupo, materias: map.get(grupo)! }))
  }, [filtered, groups])

  async function refresh() {
    await loadAppData()
    setTick((t) => t + 1)
  }

  async function handleSubmit(payload: Record<string, unknown>) {
    setBusy(true)
    try {
      await subjectService.create(payload)
      fire('Materia agregada correctamente')
      setFormOpen(false)
      await refresh()
    } catch (err) {
      fire(err instanceof ApiError ? err.message : 'No se pudo guardar la materia')
    } finally {
      setBusy(false)
    }
  }

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: 12 }}>
        <div>
          <h1 style={{ fontSize: 22, margin: 0 }}>Materias</h1>
          <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>
            Asignaturas ligadas a los horarios reales de cada grupo.
          </p>
        </div>
        <Button variant="primary" small onClick={() => setFormOpen(true)}>
          + Nueva materia
        </Button>
      </div>

      <div style={{ marginBottom: -4 }}>
        <Input value={query} onChange={setQuery} placeholder="Buscar por materia, clave o grupo…" style={{ minWidth: 260, width: '100%', maxWidth: 360 }} />
      </div>

      {groupedByGrupo.length ? (
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: `repeat(auto-fit, minmax(280px, 1fr))`,
            gap: 16,
            alignItems: 'start',
          }}
        >
          {groupedByGrupo.map(({ grupo, materias }) => (
            <Card key={grupo} style={{ padding: 0, overflow: 'hidden' }}>
              <div
                style={{
                  padding: '14px 16px',
                  background: 'linear-gradient(135deg,var(--primary),var(--navy))',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                }}
              >
                <b style={{ color: '#fff', fontSize: 14 }}>{grupo}</b>
                <Badge text={`${materias.length} ${materias.length === 1 ? 'materia' : 'materias'}`} bg="rgba(255,255,255,.18)" color="#fff" />
              </div>
              <div>
                {materias.map((s) => (
                  <div
                    key={s.id}
                    style={{
                      padding: '11px 16px',
                      borderBottom: '1px solid var(--border)',
                      display: 'flex',
                      flexDirection: 'column',
                      gap: 3,
                    }}
                  >
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', gap: 8 }}>
                      <span style={{ fontWeight: 600, fontSize: 13, lineHeight: 1.3 }}>{s.nombre}</span>
                      <span style={{ fontFamily: 'monospace', fontSize: 10.5, color: 'var(--muted-foreground)', flexShrink: 0 }}>{s.id}</span>
                    </div>
                    <span style={{ fontSize: 12, color: 'var(--muted-foreground)' }}>{s.docente || 'Sin docente asignado'}</span>
                  </div>
                ))}
              </div>
            </Card>
          ))}
        </div>
      ) : (
        <Card>
          <p style={{ padding: '18px 12px', textAlign: 'center', color: 'var(--muted-foreground)', fontSize: 13, margin: 0 }}>
            No hay materias{query ? ' que coincidan con la búsqueda' : ' registradas todavía'}.
          </p>
        </Card>
      )}

      {formOpen && (
        <SubjectFormModal groups={groups} teachers={teachers} busy={busy} onClose={() => setFormOpen(false)} onSubmit={handleSubmit} />
      )}

      <Toast message={msg} show={show} />
    </div>
  )
}

function SubjectFormModal({
  groups,
  teachers,
  busy,
  onClose,
  onSubmit,
}: {
  groups: RawGroup[]
  teachers: RawTeacher[]
  busy: boolean
  onClose: () => void
  onSubmit: (payload: Record<string, unknown>) => void
}) {
  const [id, setId] = useState('')
  const [nombre, setNombre] = useState('')
  const [groupId, setGroupId] = useState(groups[0]?.id ?? '')
  const [teacherId, setTeacherId] = useState<string>(teachers[0]?.id ?? '')
  const [creditos, setCreditos] = useState('')

  const canSubmit = id.trim() !== '' && nombre.trim() !== '' && groupId !== ''

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!canSubmit || busy) return
    const teacher = teachers.find((t) => t.id === teacherId)
    onSubmit({
      id: id.trim().toUpperCase(),
      nombre: nombre.trim(),
      group_id: groupId,
      teacher_id: teacherId || undefined,
      docente_nombre: teacher?.nombre,
      creditos: creditos ? Number(creditos) : 0,
    })
  }

  return (
    <Modal title="Nueva materia" onClose={onClose} width={480}>
      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
          <Field label="Clave *">
            <Input value={id} onChange={setId} placeholder="MAT10-81" style={{ width: '100%' }} />
          </Field>
          <Field label="Créditos">
            <Input value={creditos} onChange={setCreditos} placeholder="5" style={{ width: '100%' }} />
          </Field>
        </div>

        <Field label="Nombre de la materia *">
          <Input value={nombre} onChange={setNombre} placeholder="Programación Avanzada" style={{ width: '100%' }} />
        </Field>

        <Field label="Grupo *">
          {groups.length ? (
            <Select value={groupId} onChange={setGroupId} options={groups.map((g) => g.id)} style={{ width: '100%' }} />
          ) : (
            <span style={{ fontSize: 12.5, color: '#c2410c' }}>No se pudieron cargar los grupos. Verifica la conexión con el backend.</span>
          )}
        </Field>

        <Field label="Docente">
          {teachers.length ? (
            <Select value={teacherId} onChange={setTeacherId} options={teachers.map((t) => t.id)} style={{ width: '100%' }} />
          ) : (
            <span style={{ fontSize: 12.5, color: 'var(--muted-foreground)' }}>Sin docentes disponibles (opcional).</span>
          )}
        </Field>

        <p style={{ fontSize: 12, color: 'var(--muted-foreground)', margin: 0 }}>
          Para que la materia aparezca en el horario del grupo, asígnale un horario desde la sección Horarios después de crearla.
        </p>

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10, marginTop: 4 }}>
          <Button variant="secondary" onClick={onClose}>
            Cancelar
          </Button>
          <Button variant="primary" type="submit">
            {busy ? 'Guardando…' : 'Guardar materia'}
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