export interface Subject {
  id: string
  nombre: string
  grupo: string
  docente: string
  teacherId: string | null
  creditos: number
}

export const SUBJECTS: Subject[] = []

export function setSubjects(list: Subject[]) {
  SUBJECTS.length = 0
  SUBJECTS.push(...list)
}

export interface Career {
  id: string
  nombre: string
  siglas: string
  nivel: string
  duracion: string
  modalidad: string
  descripcion: string
}

export const CAREERS: Career[] = []

export function setCareers(list: Career[]) {
  CAREERS.length = 0
  CAREERS.push(...list)
}

export interface ScheduleSlot {
  dia: string
  hora: string
  materia: string
  docente: string
  aula: string
  grupo: string
  subjectId?: string
}

export const SCHEDULE_SLOTS: ScheduleSlot[] = []

export function setScheduleSlots(list: ScheduleSlot[]) {
  SCHEDULE_SLOTS.length = 0
  SCHEDULE_SLOTS.push(...list)
}

export function scheduleForGroup(grupo: string): ScheduleSlot[] {
  return SCHEDULE_SLOTS.filter((s) => s.grupo === grupo)
}