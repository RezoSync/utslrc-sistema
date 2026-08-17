import type { PageId, Role } from './types'
import type { IconName } from './components/Icon'
export interface NavItem { id: PageId; label: string; icon: IconName }
export interface NavGroup { label: string; items: NavItem[] }
export const NAV: NavGroup[] = [
  { label: 'General', items: [{ id: 'dashboard', label: 'Dashboard', icon: 'grid' }, { id: 'mi-espacio', label: 'Mi espacio', icon: 'student' }, { id: 'grupos', label: 'Grupos', icon: 'users' }, { id: 'alumnos', label: 'Alumnos', icon: 'student' }, { id: 'docentes', label: 'Docentes', icon: 'teacher' }] },
  { label: 'Académico', items: [{ id: 'carreras', label: 'Carreras', icon: 'target' }, { id: 'materias', label: 'Materias', icon: 'book' }, { id: 'calificaciones', label: 'Calificaciones', icon: 'check' }, { id: 'asistencia', label: 'Asistencia', icon: 'calendar' }, { id: 'horarios', label: 'Horarios', icon: 'calendar' }, { id: 'inscripciones', label: 'Inscripciones', icon: 'file' }, { id: 'kardex', label: 'Kardex', icon: 'file' }] },
  { label: 'Servicios', items: [{ id: 'biblioteca', label: 'Biblioteca', icon: 'library' }, { id: 'inventarios', label: 'Inventarios', icon: 'box' }, { id: 'plataforma-trabajos', label: 'Plataforma de Trabajos', icon: 'briefcase' }, { id: 'servicios', label: 'Servicios', icon: 'service' }, { id: 'reportes', label: 'Reportes', icon: 'chart' }] },
  { label: 'Sistema', items: [{ id: 'configuracion', label: 'Configuración', icon: 'settings' }] },
]
export const ALL_PAGE_IDS: PageId[] = NAV.flatMap((g) => g.items.map((i) => i.id))
export const ROLE_PAGES: Record<Role, PageId[]> = {
  // Administrador: gestión operativa (alumnos, docentes, grupos, materias, horarios,
  // inscripciones, biblioteca, inventarios, reportes). Calificaciones, Asistencia
  // y Kardex se consultan desde el rol correspondiente (Docente/Alumno); Carreras deja de
  // administrarse desde aquí. Servicios Escolares es exclusivo de Alumno/Vinculación.
  Administrador: ALL_PAGE_IDS.filter((id) => !['mi-espacio', 'carreras', 'calificaciones', 'asistencia', 'kardex', 'plataforma-trabajos', 'servicios'].includes(id)),
  'Control Escolar': ALL_PAGE_IDS.filter((id) => !['mi-espacio', 'servicios'].includes(id)),
  Docente: ['dashboard', 'grupos', 'alumnos', 'docentes', 'materias', 'calificaciones', 'asistencia', 'horarios', 'biblioteca', 'plataforma-trabajos'],
  Alumno: ['dashboard', 'mi-espacio', 'calificaciones', 'asistencia', 'horarios', 'kardex', 'biblioteca', 'plataforma-trabajos', 'servicios'],
  // Vinculación: rol dedicado a préstamos de biblioteca y Servicios Escolares. No debe ver
  // alumnos, docentes, calificaciones ni el resto de módulos administrativos.
  Vinculacion: [ 'biblioteca', 'servicios'],
}
export const PAGE_TITLES: Record<PageId, { title: string; subtitle: string }> = {
  dashboard: { title: 'Dashboard', subtitle: '' }, 'mi-espacio': { title: 'Mi espacio', subtitle: '' }, perfil: { title: 'Mi perfil', subtitle: 'Datos de tu cuenta y sesión' }, grupos: { title: 'Grupos', subtitle: 'Grupos activos de Tecnologías de la Información' }, alumnos: { title: 'Alumnos', subtitle: 'Expedientes, grupos y seguimiento académico' }, docentes: { title: 'Docentes', subtitle: 'Directorio académico y carga de grupos' }, carreras: { title: 'Carreras', subtitle: 'Oferta educativa institucional' }, materias: { title: 'Materias', subtitle: 'Catálogo de asignaturas por grupo' }, calificaciones: { title: 'Calificaciones', subtitle: '' }, asistencia: { title: 'Asistencia', subtitle: '' }, horarios: { title: 'Horarios', subtitle: 'Horario semanal por grupo' }, inscripciones: { title: 'Inscripciones', subtitle: 'Alumnos inscritos por carrera y periodo' }, kardex: { title: 'Kardex', subtitle: '' }, biblioteca: { title: 'Biblioteca', subtitle: ' ' }, inventarios: { title: 'Inventarios', subtitle: 'Control de activos y equipo · Escáner de laboratorio' }, 'plataforma-trabajos': { title: 'Plataforma de Trabajos', subtitle: '' }, servicios: { title: 'Servicios', subtitle: '' }, reportes: { title: 'Reportes', subtitle: 'Reportes académicos y administrativos' }, configuracion: { title: 'Configuración', subtitle: 'Perfil, usuarios, roles y configuración académica' },
}