// Capa de servicios real: cada función habla con la API REST (backend Express/MySQL)
// en vez de devolver arreglos en memoria. Úsala para altas/bajas/cambios desde las
// páginas; para lectura de listados ya poblados, las páginas siguen leyendo
// directamente de src/data/* (ver src/services/loadData.ts).
import { api } from './api'

export const studentService = {
  getAll: () => api.get('/students'),
  getByGroup: (grupo: string) => api.get(`/students?grupo=${encodeURIComponent(grupo)}`),
  getById: (id: string) => api.get(`/students/${id}`),
  search: (q: string) => api.get(`/students?q=${encodeURIComponent(q)}`),
  create: (data: unknown) => api.post('/students', data),
  update: (id: string, data: unknown) => api.put(`/students/${id}`, data),
  remove: (id: string) => api.delete(`/students/${id}`),
}

export const groupService = {
  getAll: () => api.get('/groups'),
  getById: (id: string) => api.get(`/groups/${id}`),
  average: (grupo: string) => api.get(`/groups/${grupo}/average`),
  attendance: (grupo: string) => api.get(`/groups/${grupo}/attendance`),
  create: (data: unknown) => api.post('/groups', data),
  update: (id: string, data: unknown) => api.put(`/groups/${id}`, data),
  remove: (id: string) => api.delete(`/groups/${id}`),
}

export const teacherService = {
  getAll: () => api.get('/teachers'),
  getById: (id: string) => api.get(`/teachers/${id}`),
  create: (data: unknown) => api.post('/teachers', data),
  update: (id: string, data: unknown) => api.put(`/teachers/${id}`, data),
  remove: (id: string) => api.delete(`/teachers/${id}`),
}

export const subjectService = {
  getAll: () => api.get('/subjects'),
  getByGroup: (grupo: string) => api.get(`/subjects?grupo=${encodeURIComponent(grupo)}`),
  create: (data: unknown) => api.post('/subjects', data),
  update: (id: string, data: unknown) => api.put(`/subjects/${id}`, data),
  remove: (id: string) => api.delete(`/subjects/${id}`),
}

export const inventoryService = {
  getAll: () => api.get('/inventory'),
  search: (q: string) => api.get(`/inventory?q=${encodeURIComponent(q)}`),
  scan: (code: string) => api.get(`/inventory/scan/${encodeURIComponent(code)}`),
  create: (data: unknown) => api.post('/inventory', data),
  update: (id: string, data: unknown) => api.put(`/inventory/${id}`, data),
  remove: (id: string) => api.delete(`/inventory/${id}`),
}

export const careerService = {
  getAll: () => api.get('/careers'),
  create: (data: unknown) => api.post('/careers', data),
  update: (id: string, data: unknown) => api.put(`/careers/${id}`, data),
  remove: (id: string) => api.delete(`/careers/${id}`),
}

export const scheduleService = {
  forGroup: (grupo: string) => api.get(`/schedules?grupo=${encodeURIComponent(grupo)}`),
  create: (data: unknown) => api.post('/schedules', data),
  update: (id: number, data: unknown) => api.put(`/schedules/${id}`, data),
  remove: (id: number) => api.delete(`/schedules/${id}`),
}

export const gradeService = {
  getAll: () => api.get('/grades'),
  forStudent: (studentId: string) => api.get(`/grades/student/${studentId}`),
  create: (data: unknown) => api.post('/grades', data),
  update: (id: string, data: unknown) => api.put(`/grades/${id}`, data),
  remove: (id: string) => api.delete(`/grades/${id}`),
  /** Genera el kardex oficial de un alumno directamente desde el backend/BD. */
  kardex: (studentId: string) => api.get<KardexResponse>(`/grades/kardex/${studentId}`),
}

export interface KardexMateria {
  subjectId: string
  materia: string
  creditos: number
  parcial: string
  final: number
  letra: 'NA' | 'SA' | 'DE' | 'AU'
}

export interface KardexCuatrimestre {
  cuatrimestre: string
  periodo: string
  materias: KardexMateria[]
  promedio: number
}

export interface KardexResponse {
  alumno: { id: string; expediente: string; nombre: string; carrera: string; grupo: string; status: string }
  cuatrimestres: KardexCuatrimestre[]
  resumen: { promedioGeneral: number; totalMaterias: number; acreditadas: number; noAcreditadas: number }
  generadoEn: string
}

export const attendanceService = {
  getAll: () => api.get('/attendance'),
  forStudent: (studentId: string) => api.get(`/attendance/student/${studentId}`),
  update: (studentId: string, data: unknown) => api.put(`/attendance/student/${studentId}`, data),
  /** Trae lo que ya se marcó (si algo) para esa materia/grupo/fecha. */
  /** Trae lo que ya se marcó (si algo) para esa materia/grupo/fecha. */
  session: (groupId: string, subjectId: string, fecha: string) =>
    api.get<{ student_id: string; estado: 'Presente' | 'Falta' | 'Retardo'; justificacion: string | null }[]>(
      `/attendance/session?groupId=${encodeURIComponent(groupId)}&subjectId=${encodeURIComponent(subjectId)}&fecha=${fecha}`
    ),
  /** Lista de fechas ya tomadas para esa materia/grupo, con conteos por día. */
  history: (groupId: string, subjectId: string) =>
    api.get<{ fecha: string; presentes: number; faltas: number; retardos: number; total: number }[]>(
      `/attendance/history?groupId=${encodeURIComponent(groupId)}&subjectId=${encodeURIComponent(subjectId)}`
    ),
  /** Guarda el pase de lista de un grupo/materia/fecha (un estado por alumno). */
  take: (data: { groupId: string; subjectId: string; fecha: string; registros: { studentId: string; estado: 'Presente' | 'Falta' | 'Retardo'; justificacion?: string }[] }) =>
    api.post<{ saved: number }>('/attendance/take', data),
}

export const serviceTicketService = {
  getAll: () => api.get('/services'),
  forStudent: (studentId: string) => api.get(`/services?studentId=${studentId}`),
  create: (data: unknown) => api.post('/services', data),
  update: (id: string, data: unknown) => api.put(`/services/${id}`, data),
  remove: (id: string) => api.delete(`/services/${id}`),
}

export const enrollmentService = {
  getAll: () => api.get('/enrollments'),
  forStudent: (studentId: string) => api.get(`/enrollments/student/${studentId}`),
  create: (data: unknown) => api.post('/enrollments', data),
  update: (id: string, data: unknown) => api.put(`/enrollments/${id}`, data),
  remove: (id: string) => api.delete(`/enrollments/${id}`),
}

// --- Classroom: anuncios, trabajos y entregas -----------------------------
export interface ClassroomAttachment {
  id: string
  original_name: string
  mime_type: string | null
  size_bytes: number | null
}

export interface ClassroomAnnouncement {
  kind: 'anuncio'
  id: string
  titulo: string
  mensaje: string
  created_at: string
  docente: string
  materia: string | null
}

export interface ClassroomAssignmentBase {
  kind: 'trabajo'
  id: string
  titulo: string
  descripcion: string | null
  tipo: 'Tarea' | 'Proyecto' | 'Exposición' | 'Investigación'
  fecha_limite: string | null
  created_at: string
  docente: string
  materia: string | null
  adjuntos: ClassroomAttachment[]
}

export type SubmissionStatus = 'Pendiente' | 'Entregado' | 'Con retraso' | 'Revisado'

export interface Submission {
  id: string
  assignment_id: string
  student_id: string
  status: SubmissionStatus
  comentario: string | null
  /** @deprecated legado de cuando una entrega sólo admitía un archivo — usa `adjuntos`. */
  archivo_nombre: string | null
  /** @deprecated legado de cuando una entrega sólo admitía un archivo — usa `adjuntos`. */
  archivo_ruta: string | null
  adjuntos: ClassroomAttachment[]
  calificacion: number | null
  entregado_at: string | null
  revisado_at: string | null
  alumno?: string
  expediente?: string
}

export interface ClassroomAssignmentStudentView extends ClassroomAssignmentBase {
  miEntrega: Submission | null
}

export interface ClassroomAssignmentTeacherView extends ClassroomAssignmentBase {
  resumenEntregas: { Pendiente: number; Entregado: number; 'Con retraso': number; Revisado: number; total: number }
}

export type ClassroomFeedItem = ClassroomAnnouncement | ClassroomAssignmentStudentView | ClassroomAssignmentTeacherView

export const classroomService = {
  feed: (groupId: string) => api.get<ClassroomFeedItem[]>(`/classroom/feed/${encodeURIComponent(groupId)}`),
  createAnnouncement: (data: { groupId: string; subjectId?: string; titulo: string; mensaje: string }) =>
    api.post<ClassroomAnnouncement>('/classroom/announcements', data),
  /** `formData` debe incluir los campos de texto (groupId, titulo, etc.) y, opcionalmente, hasta 5 archivos en el campo `archivos`. */
  createAssignment: (formData: FormData) => api.upload<ClassroomAssignmentTeacherView>('/classroom/assignments', formData),
  submissions: (assignmentId: string) =>
    api.get<{ assignment: unknown; entregas: Submission[] }>(`/classroom/assignments/${assignmentId}/submissions`),
  /** `formData` debe incluir `comentario` (opcional) y hasta 5 archivos en el campo `archivos`. */
  submit: (assignmentId: string, formData: FormData) => api.upload<Submission>(`/classroom/assignments/${assignmentId}/submit`, formData),
  calificar: (submissionId: string, calificacion?: number) => api.patch<Submission>(`/classroom/submissions/${submissionId}`, { calificacion }),
  /** Adjunto de un trabajo publicado por el docente (visible a todo el grupo). */
  downloadAssignmentAttachment: (assignmentId: string, attachmentId: string) =>
    api.download(`/classroom/assignments/${assignmentId}/attachments/${attachmentId}/download`),
  /** Adjunto de una entrega de alumno. */
  downloadSubmissionAttachment: (submissionId: string, attachmentId: string) =>
    api.download(`/classroom/submissions/${submissionId}/attachments/${attachmentId}/download`),
  /** @deprecated legado — descarga el único archivo de entregas viejas sin fila en `adjuntos`. */
  download: (submissionId: string) => api.download(`/classroom/submissions/${submissionId}/download`),
}

export { authService } from './auth'
export { loadAppData, loadPublicData } from './loadData'
export { ApiError } from './api'


export const libraryService = {
  getBooks: (q?: string) => api.get(`/library/books${q ? `?q=${encodeURIComponent(q)}` : ''}`),
  createBook: (data: unknown) => api.post('/library/books', data),
  updateBook: (id: string, data: unknown) => api.put(`/library/books/${id}`, data),
  removeBook: (id: string) => api.delete(`/library/books/${id}`),
  getLoans: (status?: string) => api.get(`/library/loans${status ? `?status=${status}` : ''}`),
  createLoan: (data: { book_id: string; student_id: string; fecha_limite: string }) =>
    api.post('/library/loans', data),
  devolverLoan: (id: string) => api.patch(`/library/loans/${id}/devolver`),
}