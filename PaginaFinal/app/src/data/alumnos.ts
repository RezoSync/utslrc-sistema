// Shim de compatibilidad: los módulos existentes (Biblioteca, ProcesosDigitales,
// PlataformaTrabajos, ControlAlumnado) fueron escritos contra esta API.
// La fuente real de datos ahora vive en ./students.ts
export { STUDENTS as ALUMNOS, GROUPS as GRUPOS } from './students'
export type { Student as Alumno } from './students'
