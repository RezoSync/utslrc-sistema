import { useMemo, useState } from 'react'
import { STUDENTS } from '../data/students'
import { SUBJECTS } from '../data/academic'
import { GRADES, letterGrade, LETTER_GRADE_INFO, computeFinal, toGradeRecord, upsertGrade, PARCIALES, type EvalComponents, type GradeRecord, type RawGradeRecord } from '../data/grades'
import { Card, Table, Badge, Select, Button, Input } from '../components/ui'
import { api, ApiError } from '../services/api'
import type { Role } from '../types'

interface Props {
  role?: Role
  studentId?: string | null
  teacherId?: string | null
}

const EMPTY_COMPONENTS: EvalComponents = { evidencias: 0, conocimiento: 0, desempeno: 0, actitud: 0, examen: 0 }

function GradeInput({ value, onChange, disabled }: { value: number; onChange: (v: number) => void; disabled?: boolean }) {
  return (
    <input
      type="number"
      min={0}
      max={10}
      step={0.1}
      value={Number.isFinite(value) ? value : 0}
      disabled={disabled}
      onChange={(e) => {
        const v = parseFloat(e.target.value)
        onChange(Number.isFinite(v) ? Math.min(10, Math.max(0, v)) : 0)
      }}
      style={{
        width: 56,
        padding: '6px 6px',
        borderRadius: 6,
        border: '1px solid var(--border)',
        fontSize: 12.5,
        textAlign: 'center',
        opacity: disabled ? 0.6 : 1,
      }}
    />
  )
}

export default function Calificaciones({ role, studentId, teacherId }: Props) {
  const isAlumno = role === 'Alumno'
  const isDocente = role === 'Docente'
  const isAdmin = !isAlumno && !isDocente // Administrador / Control Escolar

  // ---------------------------------------------------------------
  // Vista ALUMNO: solo sus propias calificaciones, sin edición.
  // ---------------------------------------------------------------
  const ownRows = useMemo(() => {
    if (!isAlumno || !studentId) return []
    return GRADES.filter((g) => g.studentId === studentId)
  }, [isAlumno, studentId])

  // ---------------------------------------------------------------
  // Vista DOCENTE: solo su(s) materia(s), en sus grupos, editable.
  // ---------------------------------------------------------------
  const mySubjects = useMemo(() => {
    if (!isDocente || !teacherId) return []
    return SUBJECTS.filter((s) => s.teacherId === teacherId)
  }, [isDocente, teacherId])

  const myGrupos = useMemo(() => [...new Set(mySubjects.map((s) => s.grupo))], [mySubjects])
  const [grupo, setGrupo] = useState('Todos')
  const [queryDocente, setQueryDocente] = useState('')
  const [parcialSel, setParcialSel] = useState<string>(PARCIALES[0])

  const subjectsInScope = useMemo(
    () => (grupo === 'Todos' ? mySubjects : mySubjects.filter((s) => s.grupo === grupo)),
    [mySubjects, grupo]
  )

  const docenteRows = useMemo(() => {
    const list: { subjectId: string; materia: string; grupo: string; student: (typeof STUDENTS)[number] }[] = []
    for (const subject of subjectsInScope) {
      const roster = STUDENTS.filter((s) => s.grupo === subject.grupo)
      for (const student of roster) {
        if (queryDocente.trim() && !student.nombre.toLowerCase().includes(queryDocente.toLowerCase()) && !student.expediente.includes(queryDocente)) {
          continue
        }
        list.push({ subjectId: subject.id, materia: subject.nombre, grupo: subject.grupo, student })
      }
    }
    return list
  }, [subjectsInScope, queryDocente])

  // Estado local de edición/guardado para la vista de docente.
  const [localEdits, setLocalEdits] = useState<Record<string, EvalComponents>>({})
  const [localSaved, setLocalSaved] = useState<Record<string, GradeRecord>>({})
  const [rowStatus, setRowStatus] = useState<Record<string, { saving?: boolean; error?: string; ok?: boolean }>>({})

  // La llave de fila incluye el parcial: cada parcial es un registro
  // independiente, así que cambiar de parcial no debe pisar otro guardado.
  const rowKey = (subjectId: string, sId: string, parcial: string) => `${subjectId}::${sId}::${parcial}`

  function getExisting(key: string, parcial: string) {
    return localSaved[key] ?? GRADES.find((g) => rowKey(g.subjectId, g.studentId, g.parcial) === key && g.parcial === parcial)
  }
  function getValues(key: string, parcial: string): EvalComponents {
    return localEdits[key] ?? getExisting(key, parcial)?.components ?? EMPTY_COMPONENTS
  }
  function handleChange(key: string, parcial: string, field: keyof EvalComponents, value: number) {
    setLocalEdits((prev) => ({ ...prev, [key]: { ...getValues(key, parcial), [field]: value } }))
  }
  async function handleSave(subjectId: string, sId: string, parcial: string) {
    const key = rowKey(subjectId, sId, parcial)
    setRowStatus((prev) => ({ ...prev, [key]: { saving: true } }))
    try {
      const values = getValues(key, parcial)
      const existing = getExisting(key, parcial)
      const payload = { student_id: sId, subject_id: subjectId, parcial, ...values }
      // El backend responde con la fila "cruda" (snake_case, sin anidar) —
      // hay que convertirla a GradeRecord antes de guardarla en el estado,
      // o la UI la muestra como si estuviera vacía (todo en 0) aunque en la
      // base de datos sí haya quedado guardada correctamente.
      const materia = mySubjects.find((s) => s.id === subjectId)?.nombre ?? subjectId
      const rawSaved = existing?.id
        ? await api.put<RawGradeRecord>(`/grades/${existing.id}`, payload)
        : await api.post<RawGradeRecord>('/grades', payload)
      const saved = toGradeRecord(rawSaved, materia)
      setLocalSaved((prev) => ({ ...prev, [key]: saved }))
      upsertGrade(saved) // refleja el guardado en el resto de la app (vista Alumno/Admin) sin recargar
      setLocalEdits((prev) => {
        const next = { ...prev }
        delete next[key]
        return next
      })
      setRowStatus((prev) => ({ ...prev, [key]: { ok: true } }))
      setTimeout(() => setRowStatus((prev) => ({ ...prev, [key]: {} })), 2000)
    } catch (err) {
      setRowStatus((prev) => ({
        ...prev,
        [key]: { error: err instanceof ApiError ? err.message : 'Error al guardar' },
      }))
    }
  }

  // ---------------------------------------------------------------
  // Vista ADMINISTRADOR / CONTROL ESCOLAR: consulta por alumno, solo lectura.
  // ---------------------------------------------------------------
  const [queryAdmin, setQueryAdmin] = useState('')
  const [selectedStudentId, setSelectedStudentId] = useState<string | null>(null)

  const adminMatches = useMemo(() => {
    if (isAdmin && queryAdmin.trim().length >= 2) {
      const q = queryAdmin.toLowerCase()
      return STUDENTS.filter((s) => s.nombre.toLowerCase().includes(q) || s.expediente.includes(queryAdmin)).slice(0, 8)
    }
    return []
  }, [isAdmin, queryAdmin])

  const selectedStudent = useMemo(() => STUDENTS.find((s) => s.id === selectedStudentId), [selectedStudentId])
  const adminRows = useMemo(() => {
    if (!selectedStudentId) return []
    return GRADES.filter((g) => g.studentId === selectedStudentId)
  }, [selectedStudentId])

  const studentName = (id: string) => STUDENTS.find((s) => s.id === id)?.nombre ?? id
  const studentExp = (id: string) => STUDENTS.find((s) => s.id === id)?.expediente ?? ''

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div>
        <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>
          Actividades (30%) · Examen (30%) · Tareas (20%) · Participación (10%) · Asistencia (10%)
        </p>
        <p style={{ color: 'var(--muted-foreground)', fontSize: 12, margin: '4px 0 0' }}>
          Escala: NA menor a 8.0 · SA 8.0–8.9 · DE 9.0–9.6 · AU 9.7–10
        </p>
      </div>

      {/* ---------------- ALUMNO ---------------- */}
      {isAlumno && (
        <Card>
          <Table headers={['Materia', 'Parcial', 'Activ.', 'Asist.', 'Particip.', 'Tareas', 'Examen', 'Final', '']}>
            {[...ownRows]
              .sort((a, b) => a.materia.localeCompare(b.materia) || a.parcial.localeCompare(b.parcial))
              .map((g) => (
                <tr key={g.id} style={{ borderBottom: '1px solid var(--border)' }}>
                  <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{g.materia}</td>
                  <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{g.parcial}</td>
                  <td style={{ padding: '10px 12px' }}>{g.components.evidencias}</td>
                  <td style={{ padding: '10px 12px' }}>{g.components.conocimiento}</td>
                  <td style={{ padding: '10px 12px' }}>{g.components.desempeno}</td>
                  <td style={{ padding: '10px 12px' }}>{g.components.actitud}</td>
                  <td style={{ padding: '10px 12px' }}>{g.components.examen}</td>
                  <td style={{ padding: '10px 12px', fontWeight: 700 }}>{g.final}</td>
                  <td style={{ padding: '10px 12px' }}>
                    <Badge text={letterGrade(g.final)} bg={LETTER_GRADE_INFO[letterGrade(g.final)].bg} color={LETTER_GRADE_INFO[letterGrade(g.final)].color} />
                  </td>
                </tr>
              ))}
          </Table>
          {ownRows.length === 0 && (
            <p style={{ fontSize: 13, color: 'var(--muted-foreground)', textAlign: 'center', padding: '20px 0' }}>
              Aún no tienes calificaciones registradas.
            </p>
          )}
        </Card>
      )}

      {/* ---------------- DOCENTE ---------------- */}
      {isDocente && (
        <>
          <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'center' }}>
            <Select value={grupo} onChange={setGrupo} options={['Todos', ...myGrupos]} />
            <Select value={parcialSel} onChange={setParcialSel} options={[...PARCIALES]} />
            <Input value={queryDocente} onChange={setQueryDocente} placeholder="Buscar alumno…" style={{ minWidth: 240 }} />
          </div>

          <Card>
            {mySubjects.length === 0 ? (
              <p style={{ fontSize: 13, color: 'var(--muted-foreground)', textAlign: 'center', padding: '20px 0' }}>
                Aún no tienes materias asignadas.
              </p>
            ) : (
              <Table headers={['Alumno', 'Materia', 'Activ.', 'Asist.', 'Particip.', 'Tareas', 'Examen', 'Final', '', '']}>
                {docenteRows.map(({ subjectId, materia, student }) => {
                  const key = rowKey(subjectId, student.id, parcialSel)
                  const values = getValues(key, parcialSel)
                  const final = computeFinal(values)
                  const status = rowStatus[key] || {}
                  return (
                    <tr key={key} style={{ borderBottom: '1px solid var(--border)' }}>
                      <td style={{ padding: '10px 12px' }}>
                        <b style={{ fontSize: 12.5 }}>{student.nombre}</b>
                        <div style={{ fontSize: 11, color: 'var(--muted-foreground)' }}>{student.expediente}</div>
                      </td>
                      <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{materia}</td>
                      <td style={{ padding: '10px 12px' }}>
                        <GradeInput value={values.evidencias} onChange={(v) => handleChange(key, parcialSel, 'evidencias', v)} />
                      </td>
                      <td style={{ padding: '10px 12px' }}>
                        <GradeInput value={values.conocimiento} onChange={(v) => handleChange(key, parcialSel, 'conocimiento', v)} />
                      </td>
                      <td style={{ padding: '10px 12px' }}>
                        <GradeInput value={values.desempeno} onChange={(v) => handleChange(key, parcialSel, 'desempeno', v)} />
                      </td>
                      <td style={{ padding: '10px 12px' }}>
                        <GradeInput value={values.actitud} onChange={(v) => handleChange(key, parcialSel, 'actitud', v)} />
                      </td>
                      <td style={{ padding: '10px 12px' }}>
                        <GradeInput value={values.examen} onChange={(v) => handleChange(key, parcialSel, 'examen', v)} />
                      </td>
                      <td style={{ padding: '10px 12px', fontWeight: 700 }}>{final}</td>
                      <td style={{ padding: '10px 12px' }}>
                        <Badge text={letterGrade(final)} bg={LETTER_GRADE_INFO[letterGrade(final)].bg} color={LETTER_GRADE_INFO[letterGrade(final)].color} />
                      </td>
                      <td style={{ padding: '10px 12px' }}>
                        <Button variant="primary" small disabled={status.saving} onClick={() => handleSave(subjectId, student.id, parcialSel)}>
                          {status.saving ? 'Guardando…' : status.ok ? 'Guardado ✓' : 'Guardar'}
                        </Button>
                        {status.error && <div style={{ fontSize: 10.5, color: '#b42318', marginTop: 4 }}>{status.error}</div>}
                      </td>
                    </tr>
                  )
                })}
              </Table>
            )}
            {mySubjects.length > 0 && docenteRows.length === 0 && (
              <p style={{ fontSize: 13, color: 'var(--muted-foreground)', textAlign: 'center', padding: '20px 0' }}>
                No hay alumnos que coincidan con la búsqueda.
              </p>
            )}
          </Card>
        </>
      )}

      {/* ---------------- ADMINISTRADOR / CONTROL ESCOLAR ---------------- */}
      {isAdmin && (
        <>
          <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', position: 'relative' }}>
            <Input
              value={queryAdmin}
              onChange={(v) => {
                setQueryAdmin(v)
                setSelectedStudentId(null)
              }}
              placeholder="Buscar alumno por nombre o expediente…"
              style={{ minWidth: 300 }}
            />
          </div>

          {adminMatches.length > 0 && (
            <Card style={{ padding: 8 }}>
              {adminMatches.map((s) => (
                <button
                  key={s.id}
                  onClick={() => {
                    setSelectedStudentId(s.id)
                    setQueryAdmin(s.nombre)
                  }}
                  style={{
                    display: 'block',
                    width: '100%',
                    textAlign: 'left',
                    padding: '8px 10px',
                    border: 0,
                    background: 'transparent',
                    cursor: 'pointer',
                    borderRadius: 8,
                    fontSize: 13,
                  }}
                >
                  <b>{s.nombre}</b>{' '}
                  <span style={{ color: 'var(--muted-foreground)', fontSize: 11.5 }}>
                    {s.expediente} · {s.grupo}
                  </span>
                </button>
              ))}
            </Card>
          )}

          {selectedStudent && (
            <Card>
              <div style={{ marginBottom: 12 }}>
                <b style={{ fontSize: 13.5 }}>{studentName(selectedStudent.id)}</b>
                <span style={{ color: 'var(--muted-foreground)', fontSize: 12 }}>
                  {' '}
                  · {studentExp(selectedStudent.id)} · {selectedStudent.grupo}
                </span>
              </div>
              <Table headers={['Materia', 'Parcial', 'Activ.', 'Asist.', 'Particip.', 'Tareas', 'Examen', 'Final', '']}>
                {[...adminRows]
                  .sort((a, b) => a.materia.localeCompare(b.materia) || a.parcial.localeCompare(b.parcial))
                  .map((g) => (
                    <tr key={g.id} style={{ borderBottom: '1px solid var(--border)' }}>
                      <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{g.materia}</td>
                      <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{g.parcial}</td>
                      <td style={{ padding: '10px 12px' }}>{g.components.evidencias}</td>
                      <td style={{ padding: '10px 12px' }}>{g.components.conocimiento}</td>
                      <td style={{ padding: '10px 12px' }}>{g.components.desempeno}</td>
                      <td style={{ padding: '10px 12px' }}>{g.components.actitud}</td>
                      <td style={{ padding: '10px 12px' }}>{g.components.examen}</td>
                      <td style={{ padding: '10px 12px', fontWeight: 700 }}>{g.final}</td>
                      <td style={{ padding: '10px 12px' }}>
                        <Badge text={letterGrade(g.final)} bg={LETTER_GRADE_INFO[letterGrade(g.final)].bg} color={LETTER_GRADE_INFO[letterGrade(g.final)].color} />
                      </td>
                    </tr>
                  ))}
              </Table>
              {adminRows.length === 0 && (
                <p style={{ fontSize: 13, color: 'var(--muted-foreground)', textAlign: 'center', padding: '20px 0' }}>
                  Este alumno no tiene calificaciones registradas.
                </p>
              )}
            </Card>
          )}

          {!selectedStudent && adminMatches.length === 0 && queryAdmin.trim().length < 2 && (
            <p style={{ fontSize: 13, color: 'var(--muted-foreground)', padding: '8px 0' }}>
              Busca a un alumno por nombre o expediente para consultar sus calificaciones.
            </p>
          )}
        </>
      )}
    </div>
  )
}