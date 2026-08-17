export interface Teacher {
  id: string
  nombre: string
  grado: string
  materias: string[]
  grupos: string[]
  email: string
}

export const TEACHERS: Teacher[] = []

export function setTeachers(list: Teacher[]) {
  TEACHERS.length = 0
  TEACHERS.push(...list)
}
