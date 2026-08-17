import { STUDENTS } from './students'

export interface Group {
  id: string
  nombre: string
  carrera: string
  cuatrimestre: string
  periodo: string
  aula: string
  turno: string
}

export const GROUPS_DATA: Group[] = []

export function setGroupsData(list: Group[]) {
  GROUPS_DATA.length = 0
  GROUPS_DATA.push(...list)
}

export function studentsByGroup(grupo: string) {
  return STUDENTS.filter((s) => s.grupo === grupo)
}

export function groupAverage(grupo: string) {
  const list = studentsByGroup(grupo)
  if (!list.length) return 0
  return list.reduce((a, s) => a + s.promedio, 0) / list.length
}

export function groupAttendance(grupo: string) {
  const list = studentsByGroup(grupo)
  if (!list.length) return 0
  return Math.round(list.reduce((a, s) => a + s.asistencia, 0) / list.length)
}
