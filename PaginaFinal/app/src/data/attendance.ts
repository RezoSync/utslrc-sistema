export interface AttendanceSummary {
  studentId: string
  asistencias: number
  faltas: number
  retardos: number
  porcentaje: number
  estado: 'Regular' | 'En riesgo' | 'Crítico'
}

export const ATTENDANCE: AttendanceSummary[] = []

export function setAttendance(list: AttendanceSummary[]) {
  ATTENDANCE.length = 0
  ATTENDANCE.push(...list)
}

export function attendanceFor(studentId: string) {
  return ATTENDANCE.find((a) => a.studentId === studentId)
}
