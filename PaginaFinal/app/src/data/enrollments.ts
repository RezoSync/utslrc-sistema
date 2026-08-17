export interface Enrollment {
  id: string
  studentId: string
  materia: string
  periodo: string
  status: 'Inscrito' | 'Pendiente de pago' | 'Baja'
}

export const ENROLLMENTS: Enrollment[] = []

export function setEnrollments(list: Enrollment[]) {
  ENROLLMENTS.length = 0
  ENROLLMENTS.push(...list)
}
