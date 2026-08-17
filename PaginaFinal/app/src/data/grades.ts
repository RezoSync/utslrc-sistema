export interface EvalComponents {
  evidencias: number
  conocimiento: number
  desempeno: number
  actitud: number
  examen: number
}

// Fórmula centralizada de evaluación (misma que usa el backend)
// Los nombres de campo (evidencias/conocimiento/desempeno/actitud/examen) se
// mantienen igual que en la BD, pero en la interfaz se muestran como:
// evidencias -> Actividades (30%) · conocimiento -> Asistencia (10%)
// desempeno -> Participación (10%) · actitud -> Tareas (20%) · examen -> Examen (30%)
export const WEIGHTS = { evidencias: 0.3, conocimiento: 0.1, desempeno: 0.1, actitud: 0.2, examen: 0.3 }

// Parciales disponibles para captura/consulta.
export const PARCIALES = ['Parcial 1', 'Parcial 2', 'Parcial 3'] as const
export type Parcial = (typeof PARCIALES)[number]

// Etiquetas visibles de cada rubro (nombre interno -> nombre mostrado al usuario)
export const COMPONENT_LABELS: Record<keyof EvalComponents, string> = {
  evidencias: 'Actividades',
  conocimiento: 'Asistencia',
  desempeno: 'Participación',
  actitud: 'Tareas',
  examen: 'Examen',
}

export function computeFinal(c: EvalComponents) {
  const total =
    c.evidencias * WEIGHTS.evidencias +
    c.conocimiento * WEIGHTS.conocimiento +
    c.desempeno * WEIGHTS.desempeno +
    c.actitud * WEIGHTS.actitud +
    c.examen * WEIGHTS.examen
  return Math.round(total * 10) / 10
}

// Escala institucional de acreditación (misma regla que usa el backend)
export type LetterGrade = 'NA' | 'SA' | 'DE' | 'AU'

export const LETTER_GRADE_INFO: Record<LetterGrade, { label: string; bg: string; color: string }> = {
  NA: { label: 'No acreditado', bg: '#fdeeee', color: '#b42318' },
  SA: { label: 'Satisfactorio', bg: '#eff6ff', color: '#1d4ed8' },
  DE: { label: 'Destacado', bg: '#f0faf4', color: '#15803d' },
  AU: { label: 'Autónomo', bg: '#fbf3e2', color: '#9a6a00' },
}

export function letterGrade(final: number): LetterGrade {
  if (final < 8) return 'NA'
  if (final < 9) return 'SA'
  if (final < 9.7) return 'DE'
  return 'AU'
}

export interface GradeRecord {
  id: string
  studentId: string
  subjectId: string
  materia: string
  parcial: string
  components: EvalComponents
  final: number
}

// Forma "cruda" que regresa el backend (snake_case, sin anidar) tanto en el
// GET /grades como en las respuestas de POST/PUT /grades.
export interface RawGradeRecord {
  id: string
  student_id: string
  subject_id: string
  parcial: string
  evidencias: number | string
  conocimiento: number | string
  desempeno: number | string
  actitud: number | string
  examen: number | string
  final: number | string
}

// Único punto de conversión backend -> frontend, para no repetir (y no
// desalinear) esta forma en cada lugar que reciba una calificación del API.
export function toGradeRecord(raw: RawGradeRecord, materia: string): GradeRecord {
  return {
    id: raw.id,
    studentId: raw.student_id,
    subjectId: raw.subject_id,
    materia,
    parcial: raw.parcial,
    components: {
      evidencias: Number(raw.evidencias),
      conocimiento: Number(raw.conocimiento),
      desempeno: Number(raw.desempeno),
      actitud: Number(raw.actitud),
      examen: Number(raw.examen),
    },
    final: Number(raw.final),
  }
}

export const GRADES: GradeRecord[] = []

export function setGrades(list: GradeRecord[]) {
  GRADES.length = 0
  GRADES.push(...list)
}

// Inserta o actualiza un registro puntual (p. ej. justo después de guardar
// una calificación) sin tener que recargar todo el arreglo desde el backend.
export function upsertGrade(record: GradeRecord) {
  const idx = GRADES.findIndex((g) => g.id === record.id)
  if (idx >= 0) GRADES[idx] = record
  else GRADES.push(record)
}

export function gradesForStudent(studentId: string) {
  return GRADES.filter((g) => g.studentId === studentId)
}