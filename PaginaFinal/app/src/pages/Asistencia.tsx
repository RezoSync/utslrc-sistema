import { useEffect, useMemo, useState } from 'react'
import { GROUPS, STUDENTS } from '../data/students'
import { TEACHERS } from '../data/teachers'
import { ATTENDANCE } from '../data/attendance'
import { Card, Table, Badge, Select, StatCard, ProgressBar, Button, Modal, Toast, useToast } from '../components/ui'
import { attendanceService, subjectService, ApiError } from '../services'
import { refreshAttendance } from '../services/loadData'
import type { Role } from '../types'

const ESTADO_STYLE: Record<string, { bg: string; color: string }> = {
  Regular: { bg: '#f0faf4', color: '#15803d' },
  'En riesgo': { bg: '#fff4dc', color: '#9a6a00' },
  Crítico: { bg: '#fde9e9', color: '#a33b3b' },
}

const PASE_STYLE: Record<'Presente' | 'Falta' | 'Retardo', { bg: string; color: string; border: string }> = {
  Presente: { bg: '#f0faf4', color: '#15803d', border: '#bfe8cf' },
  Falta: { bg: '#fde9e9', color: '#a33b3b', border: '#f3c6c6' },
  Retardo: { bg: '#fff4dc', color: '#9a6a00', border: '#f2dca6' },
}

interface Props {
  role?: Role
  studentId?: string | null
  teacherId?: string | null
}

export default function Asistencia({ role, studentId, teacherId }: Props) {
  const isSelf = role === 'Alumno'
  const isTeacher = role === 'Docente'
  const ownStudent = isSelf ? STUDENTS.find((s) => s.id === studentId) : undefined
  const teacherRecord = isTeacher ? TEACHERS.find((t) => t.id === teacherId) : undefined
  const teacherGroups = teacherRecord?.grupos ?? []

  const [grupo, setGrupo] = useState(isTeacher ? teacherGroups[0] ?? GROUPS[0] : GROUPS[0])
  const [showTomar, setShowTomar] = useState(false)
  const [showHistorial, setShowHistorial] = useState(false)
  const [editTarget, setEditTarget] = useState<{ subjectId: string; fecha: string } | null>(null)
  const [refreshKey, setRefreshKey] = useState(0)

  const rows = useMemo(() => {
    if (isSelf) {
      if (!studentId) return []
      return ATTENDANCE.filter((a) => a.studentId === studentId)
    }
    const ids = new Set(STUDENTS.filter((s) => s.grupo === grupo).map((s) => s.id))
    return ATTENDANCE.filter((a) => ids.has(a.studentId))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [grupo, isSelf, studentId, refreshKey])

  const studentOf = (id: string) => STUDENTS.find((s) => s.id === id)!
  const promedio = Math.round(rows.reduce((a, r) => a + r.porcentaje, 0) / (rows.length || 1))
  const faltas = rows.reduce((a, r) => a + r.faltas, 0)
  const retardos = rows.reduce((a, r) => a + r.retardos, 0)

  const groupOptions = isTeacher && teacherGroups.length > 0 ? teacherGroups : [...GROUPS]

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <div>
          <h1 style={{ fontSize: 22, margin: 0 }}>{isSelf ? '' : 'Asistencia'}</h1>
          <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>
            {isSelf ? `Seguimiento de asistencia · ${ownStudent?.grupo ?? ''}` : 'Seguimiento de asistencia por grupo.'}
          </p>
        </div>
        {!isSelf && (
          <div style={{ display: 'flex', gap: 10 }}>
            <Select value={grupo} onChange={setGrupo} options={groupOptions} />
            {isTeacher && (
              <>
                <Button variant="ghost" small onClick={() => setShowHistorial(true)}>
                  Ver historial
                </Button>
                <Button variant="primary" small onClick={() => setShowTomar(true)}>
                  + Tomar asistencia
                </Button>
              </>
            )}
          </div>
        )}
      </div>

      <div className="rg-4" style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 14 }}>
        <StatCard label="Promedio" value={`${promedio}%`} icon="◷" tint="var(--secondary)" />
        <StatCard label="Faltas" value={faltas} icon="◈" tint="#fde9e9" />
        <StatCard label="Retardos" value={retardos} icon="▥" tint="var(--gold-light)" />
        {!isSelf && <StatCard label="Alumnos" value={rows.length} icon="◍" tint="#eff6ff" />}
      </div>

      <Card>
        <Table headers={isSelf ? ['Asistencias', 'Faltas', 'Retardos', '%', 'Estado'] : ['Alumno', 'Asistencias', 'Faltas', 'Retardos', '%', 'Estado']}>
          {rows.map((r) => (
            <tr key={r.studentId} style={{ borderBottom: '1px solid var(--border)' }}>
              {!isSelf && <td style={{ padding: '10px 12px', fontWeight: 500 }}>{studentOf(r.studentId).nombre}</td>}
              <td style={{ padding: '10px 12px' }}>{r.asistencias}</td>
              <td style={{ padding: '10px 12px' }}>{r.faltas}</td>
              <td style={{ padding: '10px 12px' }}>{r.retardos}</td>
              <td style={{ padding: '10px 12px', width: 140 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <div style={{ flex: 1 }}>
                    <ProgressBar value={r.porcentaje} />
                  </div>
                  <span style={{ fontSize: 11.5 }}>{r.porcentaje}%</span>
                </div>
              </td>
              <td style={{ padding: '10px 12px' }}>
                <Badge text={r.estado} bg={ESTADO_STYLE[r.estado].bg} color={ESTADO_STYLE[r.estado].color} />
              </td>
            </tr>
          ))}
        </Table>
        {rows.length === 0 && (
          <p style={{ fontSize: 13, color: 'var(--muted-foreground)', textAlign: 'center', padding: '20px 0' }}>
            {isSelf ? 'Aún no tienes registros de asistencia.' : 'Aún no hay asistencia registrada para este grupo.'}
          </p>
        )}
      </Card>

      {showTomar && teacherId && (
        <TomarAsistenciaModal
          grupo={grupo}
          teacherId={teacherId}
          onClose={() => setShowTomar(false)}
          onSaved={() => setRefreshKey((k) => k + 1)}
        />
      )}

      {showHistorial && teacherId && (
        <HistorialModal
          grupo={grupo}
          teacherId={teacherId}
          onClose={() => setShowHistorial(false)}
          onPick={(target) => {
            setShowHistorial(false)
            setEditTarget(target)
          }}
        />
      )}

      {editTarget && teacherId && (
        <TomarAsistenciaModal
          grupo={grupo}
          teacherId={teacherId}
          initialSubjectId={editTarget.subjectId}
          initialFecha={editTarget.fecha}
          onClose={() => setEditTarget(null)}
          onSaved={() => setRefreshKey((k) => k + 1)}
        />
      )}
    </div>
  )
}

interface SubjectOption {
  id: string
  nombre: string
}

type Estado = 'Presente' | 'Falta' | 'Retardo'
interface RegistroAlumno {
  estado: Estado
  justificacion: string
}

// OJO: no usar toISOString() aquí — convierte a UTC y en Sonora (UTC-7) eso
// hace que "hoy" se adelante un día por la tarde/noche. Usamos los
// componentes de fecha locales para que coincida con el calendario del
// usuario.
function todayISO() {
  const d = new Date()
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${day}`
}

function TomarAsistenciaModal({
  grupo,
  teacherId,
  initialSubjectId,
  initialFecha,
  onClose,
  onSaved,
}: {
  grupo: string
  teacherId: string
  initialSubjectId?: string
  initialFecha?: string
  onClose: () => void
  onSaved: () => void
}) {
  const alumnos = useMemo(() => STUDENTS.filter((s) => s.grupo === grupo && s.status === 'Activo'), [grupo])

  const [subjects, setSubjects] = useState<SubjectOption[]>([])
  const [subjectId, setSubjectId] = useState(initialSubjectId ?? '')
  const [fecha, setFecha] = useState(initialFecha ?? todayISO())
  const [registros, setRegistros] = useState<Record<string, RegistroAlumno>>({})
  const [loadingSession, setLoadingSession] = useState(false)
  const [saving, setSaving] = useState(false)
  const [err, setErr] = useState('')
  const { msg, show, fire } = useToast()

  // Materias que este docente imparte en este grupo.
  useEffect(() => {
    subjectService
      .getByGroup(grupo)
      .then((rows) => {
        const list = rows as { id: string; nombre: string; teacher_id: string | null }[]
        const own = list.filter((r) => r.teacher_id === teacherId).map((r) => ({ id: r.id, nombre: r.nombre }))
        setSubjects(own)
        if (!subjectId && own.length > 0) setSubjectId(own[0].id)
      })
      .catch(() => setSubjects([]))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [grupo])

  // Al elegir materia/fecha: si ya se tomó asistencia ese día, la precarga;
  // si no, todos arrancan como "Presente" (lo más común, agiliza el pase de lista).
  useEffect(() => {
    if (!subjectId || !fecha) return
    setLoadingSession(true)
    setErr('')
    attendanceService
      .session(grupo, subjectId, fecha)
      .then((existing) => {
        const base: Record<string, RegistroAlumno> = {}
        for (const a of alumnos) base[a.id] = { estado: 'Presente', justificacion: '' }
        for (const e of existing) base[e.student_id] = { estado: e.estado, justificacion: e.justificacion || '' }
        setRegistros(base)
      })
      .catch((e) => setErr(e instanceof ApiError ? e.message : 'No se pudo cargar la asistencia de ese día.'))
      .finally(() => setLoadingSession(false))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [subjectId, fecha, grupo])

  const marcarTodos = (estado: Estado) => {
    const next: Record<string, RegistroAlumno> = {}
    for (const a of alumnos) next[a.id] = { estado, justificacion: registros[a.id]?.justificacion ?? '' }
    setRegistros(next)
  }

  const guardar = async () => {
    if (!subjectId) {
      setErr('Elige una materia.')
      return
    }
    setSaving(true)
    setErr('')
    try {
      await attendanceService.take({
        groupId: grupo,
        subjectId,
        fecha,
        registros: alumnos.map((a) => ({
          studentId: a.id,
          estado: registros[a.id]?.estado ?? 'Presente',
          justificacion: registros[a.id]?.justificacion?.trim() || undefined,
        })),
      })
      await refreshAttendance()
      fire('Asistencia guardada')
      onSaved()
      onClose()
    } catch (e) {
      setErr(e instanceof ApiError ? e.message : 'No se pudo guardar la asistencia.')
    } finally {
      setSaving(false)
    }
  }

  return (
    <Modal title={`Tomar asistencia · ${grupo}`} onClose={onClose} width={640}>
      <div style={{ display: 'grid', gap: 14 }}>
        <div className="rg-2" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          <select
            value={subjectId}
            onChange={(e) => setSubjectId(e.target.value)}
            style={{ padding: '9px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13.5, background: '#fff' }}
          >
            {subjects.length === 0 && <option value="">Sin materias en este grupo</option>}
            {subjects.map((s) => (
              <option key={s.id} value={s.id}>
                {s.nombre}
              </option>
            ))}
          </select>
          <input
            type="date"
            value={fecha}
            max={todayISO()}
            disabled
            readOnly
            title={initialFecha ? 'Editando la asistencia de este día (desde el historial)' : 'Solo puedes tomar asistencia del día de hoy'}
            style={{ padding: '9px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13.5, background: '#f4f4f4', color: 'var(--muted-foreground)' }}
          />
        </div>

        <div style={{ display: 'flex', gap: 8 }}>
          <Button variant="ghost" small onClick={() => marcarTodos('Presente')}>
            Marcar todos presentes
          </Button>
          <Button variant="ghost" small onClick={() => marcarTodos('Falta')}>
            Marcar todos falta
          </Button>
        </div>

        {loadingSession ? (
          <p style={{ fontSize: 13, color: 'var(--muted-foreground)' }}>Cargando…</p>
        ) : alumnos.length === 0 ? (
          <p style={{ fontSize: 13, color: 'var(--muted-foreground)' }}>Este grupo no tiene alumnos activos.</p>
        ) : (
          <div style={{ display: 'grid', gap: 6, maxHeight: 360, overflowY: 'auto' }}>
            {alumnos.map((a) => {
              const reg = registros[a.id] ?? { estado: 'Presente' as Estado, justificacion: '' }
              const mostrarJustificacion = reg.estado === 'Falta' || reg.estado === 'Retardo'
              return (
                <div
                  key={a.id}
                  style={{ display: 'flex', flexDirection: 'column', gap: 8, padding: '8px 10px', border: '1px solid var(--border)', borderRadius: 10 }}
                >
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 10 }}>
                    <div style={{ minWidth: 0 }}>
                      <div style={{ fontSize: 13, fontWeight: 600, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{a.nombre}</div>
                      <div style={{ fontSize: 11, color: 'var(--muted-foreground)' }}>{a.expediente}</div>
                    </div>
                    <div style={{ display: 'flex', gap: 4, flexShrink: 0 }}>
                      {(['Presente', 'Falta', 'Retardo'] as const).map((estado) => {
                        const active = reg.estado === estado
                        const style = PASE_STYLE[estado]
                        return (
                          <button
                            key={estado}
                            type="button"
                            onClick={() =>
                              setRegistros((r) => ({
                                ...r,
                                [a.id]: { estado, justificacion: r[a.id]?.justificacion ?? '' },
                              }))
                            }
                            style={{
                              padding: '5px 10px',
                              borderRadius: 999,
                              fontSize: 11.5,
                              fontWeight: 700,
                              cursor: 'pointer',
                              border: `1px solid ${active ? style.border : 'var(--border)'}`,
                              background: active ? style.bg : '#fff',
                              color: active ? style.color : 'var(--muted-foreground)',
                            }}
                          >
                            {estado}
                          </button>
                        )
                      })}
                    </div>
                  </div>
                  {mostrarJustificacion && (
                    <input
                      type="text"
                      value={reg.justificacion}
                      onChange={(e) =>
                        setRegistros((r) => ({
                          ...r,
                          [a.id]: { estado: reg.estado, justificacion: e.target.value },
                        }))
                      }
                      placeholder={`Justificación de ${reg.estado.toLowerCase()} (opcional)`}
                      style={{
                        padding: '6px 10px',
                        borderRadius: 7,
                        border: '1px solid var(--border)',
                        fontSize: 12.5,
                      }}
                    />
                  )}
                </div>
              )
            })}
          </div>
        )}

        {err && <span style={{ fontSize: 12, color: '#b42318' }}>{err}</span>}

        <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
          <Button variant="secondary" onClick={onClose}>
            Cancelar
          </Button>
          <Button variant="primary" onClick={guardar}>
            {saving ? 'Guardando…' : 'Guardar asistencia'}
          </Button>
        </div>
      </div>

      <Toast message={msg} show={show} />
    </Modal>
  )
}

function HistorialModal({
  grupo,
  teacherId,
  onClose,
  onPick,
}: {
  grupo: string
  teacherId: string
  onClose: () => void
  onPick: (target: { subjectId: string; fecha: string }) => void
}) {
  const [subjects, setSubjects] = useState<SubjectOption[]>([])
  const [subjectId, setSubjectId] = useState('')
  const [dias, setDias] = useState<{ fecha: string; presentes: number; faltas: number; retardos: number; total: number }[]>([])
  const [loadingSubjects, setLoadingSubjects] = useState(true)
  const [loadingDias, setLoadingDias] = useState(false)
  const [err, setErr] = useState('')

  useEffect(() => {
    setLoadingSubjects(true)
    subjectService
      .getByGroup(grupo)
      .then((rows) => {
        const list = rows as { id: string; nombre: string; teacher_id: string | null }[]
        const own = list.filter((r) => r.teacher_id === teacherId).map((r) => ({ id: r.id, nombre: r.nombre }))
        setSubjects(own)
        if (own.length > 0) setSubjectId(own[0].id)
      })
      .catch(() => setSubjects([]))
      .finally(() => setLoadingSubjects(false))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [grupo])

  useEffect(() => {
    if (!subjectId) return
    setLoadingDias(true)
    setErr('')
    attendanceService
      .history(grupo, subjectId)
      .then(setDias)
      .catch((e) => setErr(e instanceof ApiError ? e.message : 'No se pudo cargar el historial.'))
      .finally(() => setLoadingDias(false))
  }, [grupo, subjectId])

  const formatFecha = (iso: string) => {
    const [y, m, d] = iso.slice(0, 10).split('-')
    return `${d}/${m}/${y}`
  }

  return (
    <Modal title={`Historial de asistencia · ${grupo}`} onClose={onClose} width={560}>
      <div style={{ display: 'grid', gap: 14 }}>
        <select
          value={subjectId}
          onChange={(e) => setSubjectId(e.target.value)}
          disabled={loadingSubjects}
          style={{ padding: '9px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13.5, background: '#fff' }}
        >
          {subjects.length === 0 && <option value="">Sin materias en este grupo</option>}
          {subjects.map((s) => (
            <option key={s.id} value={s.id}>
              {s.nombre}
            </option>
          ))}
        </select>

        {err && <span style={{ fontSize: 12, color: '#b42318' }}>{err}</span>}

        {loadingDias ? (
          <p style={{ fontSize: 13, color: 'var(--muted-foreground)' }}>Cargando…</p>
        ) : dias.length === 0 ? (
          <p style={{ fontSize: 13, color: 'var(--muted-foreground)', textAlign: 'center', padding: '16px 0' }}>
            Aún no hay asistencia tomada en esta materia.
          </p>
        ) : (
          <div style={{ display: 'grid', gap: 6, maxHeight: 400, overflowY: 'auto' }}>
            {dias.map((d) => (
              <button
                key={d.fecha}
                type="button"
                onClick={() => onPick({ subjectId, fecha: d.fecha.slice(0, 10) })}
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  gap: 10,
                  padding: '10px 12px',
                  border: '1px solid var(--border)',
                  borderRadius: 10,
                  background: '#fff',
                  cursor: 'pointer',
                  textAlign: 'left',
                }}
              >
                <span style={{ fontSize: 13, fontWeight: 600 }}>{formatFecha(d.fecha)}</span>
                <span style={{ display: 'flex', gap: 8, fontSize: 11.5 }}>
                  <span style={{ color: '#15803d' }}>{d.presentes} presentes</span>
                  <span style={{ color: '#a33b3b' }}>{d.faltas} faltas</span>
                  <span style={{ color: '#9a6a00' }}>{d.retardos} retardos</span>
                </span>
              </button>
            ))}
          </div>
        )}

        <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
          <Button variant="secondary" onClick={onClose}>
            Cerrar
          </Button>
        </div>
      </div>
    </Modal>
  )
}