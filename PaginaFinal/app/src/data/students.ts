// Datos reales de alumnos (Excel IDGS 8-1, 8-2, 8-3) + campos académicos demo
export interface Student {
  id: string
  no: number
  expediente: string
  nombre: string
  grupo: string
  email: string
  status: 'Activo' | 'Baja temporal' | 'Egresado'
  carrera: string
  cuatrimestre: string
  periodo: string
  promedio: number
  asistencia: number
}

export const GROUPS: string[] = []

export function setGroups(list: string[]) {
  GROUPS.length = 0
  GROUPS.push(...list)
}

export const STUDENTS: Student[] = []

export function setStudents(list: Student[]) {
  STUDENTS.length = 0
  STUDENTS.push(...list)
}
