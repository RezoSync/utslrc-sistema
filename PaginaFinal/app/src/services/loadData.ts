// Puentea el backend real con los módulos de datos que consumen las páginas.
// Las páginas siguen leyendo los mismos arreglos (STUDENTS, TEACHERS, etc.);
// aquí es donde esos arreglos se llenan con datos reales de MySQL.
import { api, getStoredUser } from './api'
import type { AuthUser } from './auth'
import { setStudents, setGroups, type Student } from '../data/students'
import { setTeachers, type Teacher } from '../data/teachers'
import { setSubjects, setCareers, setScheduleSlots, type Subject, type Career, type ScheduleSlot } from '../data/academic'
import { setGroupsData, type Group } from '../data/groups'
import { setGrades, toGradeRecord, type GradeRecord } from '../data/grades'
import { setAttendance, type AttendanceSummary } from '../data/attendance'
import { setTickets, type ServiceTicket } from '../data/services'
import { setEnrollments, type Enrollment } from '../data/enrollments'
import { setBooks, setLoans, type Libro, type Prestamo } from '../data/biblioteca'

// --- filas crudas tal como las devuelve la API (nombres de columna MySQL) ---
interface RawStudent {
  id: string
  no: number
  expediente: string
  nombre: string
  group_id: string
  email: string
  status: Student['status']
  career_id: string
  cuatrimestre: string
  periodo: string
  promedio: number
  asistencia: number
}
interface RawSubject {
  id: string
  nombre: string
  group_id: string
  teacher_id: string | null
  docente_nombre: string | null
  creditos: number
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
interface RawSchedule {
  id: number
  group_id: string
  dia: string
  hora: string
  aula: string
  subject_id: string
  materia: string
  docente: string
}
interface RawGrade {
  id: string
  student_id: string
  subject_id: string
  parcial: string
  evidencias: number
  conocimiento: number
  desempeno: number
  actitud: number
  examen: number
  final: number
}
interface RawAttendance {
  student_id: string
  asistencias: number
  faltas: number
  retardos: number
  porcentaje: number
  estado: AttendanceSummary['estado']
}
interface RawTicket {
  id: string
  folio: string
  student_id: string
  tipo: string
  descripcion: string | null
  categoria: ServiceTicket['categoria']
  fecha: string
  status: string
}
interface RawEnrollment {
  id: string
  student_id: string
  subject_id: string
  periodo: string
  status: Enrollment['status']
}


interface RawBook {
  id: string
  isbn: string | null
  titulo: string
  autor: string
  categoria: string
  ejemplares: number
  disponibles: number
  portada: string | null
  google_books_id: string | null
}
interface RawLoan {
  id: string
  book_id: string
  student_id: string
  fecha_prestamo: string
  fecha_limite: string
  fecha_devolucion: string | null
  status: Prestamo['status']
  libro_titulo: string
  alumno_nombre: string
}


function mapAttendance(rawAttendance: RawAttendance[]): AttendanceSummary[] {
  return rawAttendance.map((a) => ({
    studentId: a.student_id,
    asistencias: a.asistencias,
    faltas: a.faltas,
    retardos: a.retardos,
    porcentaje: Number(a.porcentaje),
    estado: a.estado,
  }))
}

/** Vuelve a pedir el resumen de asistencia al backend y refresca ATTENDANCE.
 *  Se llama tras tomar/editar asistencia para que la tabla en pantalla
 *  refleje lo que ya se guardó, sin necesidad de recargar toda la app. */
export async function refreshAttendance() {
  const rawAttendance = await api.get<RawAttendance[]>('/attendance')
  setAttendance(mapAttendance(rawAttendance))
}

/** Carga los datos públicos (sin login) para el portal. */
export async function loadPublicData() {
  const [careers, teachers] = await Promise.all([
    api.get<Career[]>('/public/careers'),
    api.get<Teacher[]>('/public/teachers'),
  ])
  setCareers(careers)
  setTeachers(teachers as Teacher[])
  const stats = await api.get<{ totalStudents: number; promedioGlobal: number; totalGroups: number; totalCareers: number }>(
    '/public/stats'
  )
  return stats
}

/** Carga todo el set de datos autenticado, tras iniciar sesión. */
export async function loadAppData() {
  const [rawCareers, rawSubjects, teachers, rawGroups, rawStudents] = await Promise.all([
    api.get<Career[]>('/careers'),
    api.get<RawSubject[]>('/subjects'),
    api.get<Teacher[]>('/teachers'),
    api.get<RawGroup[]>('/groups'),
    api.get<RawStudent[]>('/students'),
  ])

  setCareers(rawCareers)
  setTeachers(teachers)

  const careerName = (id: string) => rawCareers.find((c) => c.id === id)?.nombre || id

  const subjects: Subject[] = rawSubjects.map((s) => ({
    id: s.id,
    nombre: s.nombre,
    grupo: s.group_id,
    docente: s.docente_nombre || '',
    teacherId: s.teacher_id || null,
    creditos: s.creditos,
  }))
  setSubjects(subjects)
  const subjectName = (id: string) => subjects.find((s) => s.id === id)?.nombre || id

  const groups: Group[] = rawGroups.map((g) => ({
    id: g.id,
    nombre: g.nombre,
    carrera: careerName(g.career_id),
    cuatrimestre: g.cuatrimestre,
    periodo: g.periodo,
    aula: g.aula,
    turno: g.turno,
  }))
  setGroupsData(groups)
  setGroups(rawGroups.map((g) => g.id))

  const students: Student[] = rawStudents.map((s) => ({
    id: s.id,
    no: s.no,
    expediente: s.expediente,
    nombre: s.nombre,
    grupo: s.group_id,
    email: s.email,
    status: s.status,
    carrera: careerName(s.career_id),
    cuatrimestre: s.cuatrimestre,
    periodo: s.periodo,
    promedio: Number(s.promedio),
    asistencia: Number(s.asistencia),
  }))
  setStudents(students)
  const studentName = (id: string) => students.find((s) => s.id === id)?.nombre || id

  const [rawSchedules, rawGrades, rawAttendance, rawTickets, rawEnrollments, rawBooks] = await Promise.all([
    api.get<RawSchedule[]>('/schedules'),
    api.get<RawGrade[]>('/grades'),
    api.get<RawAttendance[]>('/attendance'),
    api.get<RawTicket[]>('/services'),
    api.get<RawEnrollment[]>('/enrollments'),
    api.get<RawBook[]>('/library/books'),
  ])

  // Los préstamos son exclusivos del rol Vinculación (el endpoint devuelve
  // 403 para cualquier otro rol), así que sólo se piden en ese caso.
  const currentRole = getStoredUser<AuthUser>()?.role
  const rawLoans: RawLoan[] = currentRole === 'Vinculacion' ? await api.get<RawLoan[]>('/library/loans') : []

  const scheduleSlots: ScheduleSlot[] = rawSchedules.map((s) => ({
    dia: s.dia,
    hora: s.hora,
    materia: s.materia,
    docente: s.docente,
    aula: s.aula,
    grupo: s.group_id,
    subjectId: s.subject_id,
  }))
  setScheduleSlots(scheduleSlots)

  const grades: GradeRecord[] = rawGrades.map((g) => toGradeRecord(g, subjectName(g.subject_id)))
  setGrades(grades)

  setAttendance(mapAttendance(rawAttendance))

  const tickets: ServiceTicket[] = rawTickets.map((t) => ({
    id: t.id,
    folio: t.folio,
    solicitante: studentName(t.student_id),
    tipo: t.tipo,
    descripcion: t.descripcion,
    categoria: t.categoria,
    fecha: t.fecha,
    status: t.status,
  }))
  setTickets(tickets)

  const enrollments: Enrollment[] = rawEnrollments.map((e) => ({
    id: e.id,
    studentId: e.student_id,
    materia: subjectName(e.subject_id),
    periodo: e.periodo,
    status: e.status,
  }))
  setEnrollments(enrollments)


  const books: Libro[] = rawBooks.map((b) => ({
    id: b.id,
    isbn: b.isbn || '',
    titulo: b.titulo,
    autor: b.autor,
    categoria: b.categoria,
    ejemplares: b.ejemplares,
    disponibles: b.disponibles,
    portada: b.portada || undefined,
    googleBooksId: b.google_books_id || undefined,
  }))
  setBooks(books)

  const loans: Prestamo[] = rawLoans.map((l) => ({
    id: l.id,
    bookId: l.book_id,
    libro: l.libro_titulo,
    studentId: l.student_id,
    alumno: l.alumno_nombre,
    fechaPrestamo: l.fecha_prestamo,
    fechaLimite: l.fecha_limite,
    fechaDevolucion: l.fecha_devolucion,
    status: l.status,
  }))
  setLoans(loans)
}