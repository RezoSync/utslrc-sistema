import { STUDENTS } from '../data/students'
import { groupAverage, groupAttendance } from '../data/groups'
import { Card, Badge } from '../components/ui'
import { Icon } from '../components/Icon'
import type { IconName } from '../components/Icon'
import type { PageId } from '../types'

const STATUS_STYLE: Record<string, { bg: string; color: string }> = {
  Activo: { bg: 'var(--status-active-bg)', color: 'var(--status-active-fg)' },
  'Baja temporal': { bg: 'var(--status-hold-bg)', color: 'var(--status-hold-fg)' },
  Egresado: { bg: 'var(--status-graduated-bg)', color: 'var(--status-graduated-fg)' },
}

function greeting() {
  const h = new Date().getHours()
  if (h < 12) return 'Buenos días'
  if (h < 19) return 'Buenas tardes'
  return 'Buenas noches'
}

interface Action {
  page: PageId
  title: string
  description: string
  icon: IconName
  tint: string
  fg: string
  button: string
}

// Los dos trámites que requieren un documento o expediente formal se
// presentan como tarjetas destacadas; el resto de los servicios a los que
// un alumno tiene acceso son accesos rápidos de menor peso — así el portal
// tiene una jerarquía en vez de una cuadrícula uniforme de cajas iguales.
const PRIMARY_ACTIONS: Action[] = [
  {
    page: 'calificaciones',
    title: 'Mis calificaciones',
    description: 'Consulta tus parciales, promedio y materias cursadas en el cuatrimestre actual.',
    icon: 'chart',
    tint: 'var(--secondary)',
    fg: 'var(--primary-dark)',
    button: 'Ver calificaciones',
  },
  {
    page: 'kardex',
    title: 'Mi Kardex',
    description: 'Genera tu historial académico oficial, con folio y sello digital, listo para imprimir.',
    icon: 'file',
    tint: 'var(--gold-light)',
    fg: '#92660e',
    button: 'Abrir Kardex',
  },
]

const QUICK_LINKS: Action[] = [
  { page: 'asistencia', title: 'Asistencia', description: 'Tu registro de faltas y retardos por materia.', icon: 'calendar', tint: 'var(--status-graduated-bg)', fg: 'var(--status-graduated-fg)', button: '' },
  { page: 'horarios', title: 'Horarios', description: 'Tu horario semanal de clases.', icon: 'calendar', tint: 'var(--secondary)', fg: 'var(--primary-dark)', button: '' },
  { page: 'plataforma-trabajos', title: 'Plataforma de trabajos', description: 'Entregas, anuncios y avisos de tus docentes.', icon: 'briefcase', tint: 'var(--gold-light)', fg: '#92660e', button: '' },
  { page: 'biblioteca', title: 'Biblioteca', description: 'Acervo disponible y tus préstamos activos.', icon: 'library', tint: 'var(--status-active-bg)', fg: 'var(--status-active-fg)', button: '' },
  { page: 'servicios', title: 'Servicios escolares', description: 'Solicita constancias y trámites administrativos.', icon: 'service', tint: 'var(--status-hold-bg)', fg: 'var(--status-hold-fg)', button: '' },
]

export default function MiEspacio({ onNavigate, studentId }: { onNavigate: (page: PageId) => void; studentId?: string | null }) {
  const student = STUDENTS.find((s) => s.id === studentId)

  return (
    <div className="p-6 md:p-7 max-w-[1180px] mx-auto flex flex-col gap-6">
      {student ? (
        <div className="flex flex-col sm:flex-row sm:items-center gap-4 justify-between">
          <div>
            <h1 className="m-0 text-[length:var(--text-lg)]">{greeting()}, {student.nombre.split(' ')[0]}</h1>
            <p className="mt-1.5 mb-0 max-w-[640px] leading-[1.7] text-[length:var(--text-sm)] text-[var(--muted-foreground)]">
              {student.carrera} · {student.grupo} · Cuatrimestre {student.cuatrimestre} · {student.periodo}
            </p>
          </div>
          <Badge text={student.status} bg={STATUS_STYLE[student.status].bg} color={STATUS_STYLE[student.status].color} />
        </div>
      ) : (
        <div>
          <p className="mt-1.5 mb-0 max-w-[640px] leading-[1.7] text-[length:var(--text-sm)] text-[var(--muted-foreground)]">
            Consulta tu información escolar y completa tus trámites desde un solo lugar.
          </p>
        </div>
      )}

      {student && (
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3.5">
          <Snapshot label="Mi promedio" value={student.promedio.toFixed(1)} icon="chart" />
          <Snapshot label="Mi asistencia" value={`${student.asistencia}%`} icon="calendar" />
          <Snapshot label="Promedio del grupo" value={groupAverage(student.grupo).toFixed(1)} icon="users" />
          <Snapshot label="Asistencia del grupo" value={`${Math.round(groupAttendance(student.grupo))}%`} icon="target" />
        </div>
      )}

      <div>
        <h2 className="m-0 mb-3.5 text-[length:var(--text-base)]">Documentos y trámites</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4.5">
          {PRIMARY_ACTIONS.map((item) => (
            <article
              key={item.page}
              className="group flex flex-col bg-white border border-[var(--border)] rounded-[18px] p-6 min-h-[220px] transition-shadow hover:shadow-[var(--shadow)]"
            >
              <div
                className="grid place-items-center w-[46px] h-[46px] rounded-[13px]"
                style={{ background: item.tint, color: item.fg }}
                aria-hidden="true"
              >
                <Icon name={item.icon} size={23} />
              </div>
              <h3 className="mt-5 mb-2 text-[length:var(--text-xl)] font-normal">{item.title}</h3>
              <p className="m-0 text-[length:var(--text-sm)] leading-[1.65] text-[var(--muted-foreground)]">
                {item.description}
              </p>
              <button
                onClick={() => onNavigate(item.page)}
                className="mt-auto self-start min-h-[44px] rounded-[9px] border-0 px-3.5 py-2.5 font-extrabold text-white cursor-pointer"
                style={{ background: 'var(--primary-action)' }}
              >
                {item.button}
              </button>
            </article>
          ))}
        </div>
      </div>

      <div>
        <h2 className="m-0 mb-3.5 text-[length:var(--text-base)]">Accesos rápidos</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
          {QUICK_LINKS.map((item) => (
            <button
              key={item.page}
              onClick={() => onNavigate(item.page)}
              className="flex items-center gap-3 text-left bg-white border border-[var(--border)] rounded-[14px] p-3.5 min-h-[44px] cursor-pointer transition-colors hover:border-[var(--primary)] hover:bg-[var(--muted)]"
            >
              <div
                className="grid place-items-center w-9 h-9 rounded-[10px] shrink-0"
                style={{ background: item.tint, color: item.fg }}
                aria-hidden="true"
              >
                <Icon name={item.icon} size={17} />
              </div>
              <div className="min-w-0">
                <b className="block text-[length:var(--text-sm)]">{item.title}</b>
                <span className="block truncate text-[length:var(--text-2xs)] text-[var(--muted-foreground)]">{item.description}</span>
              </div>
              <Icon name="eye" size={15} style={{ color: 'var(--muted-foreground)', marginLeft: 'auto', flexShrink: 0 }} />
            </button>
          ))}
        </div>
      </div>
    </div>
  )
}

function Snapshot({ label, value, icon }: { label: string; value: string; icon: IconName }) {
  return (
    <Card style={{ display: 'flex', alignItems: 'center', gap: 12, padding: 16 }}>
      <div
        className="grid place-items-center w-9 h-9 rounded-[10px] shrink-0"
        style={{ background: 'var(--secondary)', color: 'var(--primary-dark)' }}
        aria-hidden="true"
      >
        <Icon name={icon} size={17} />
      </div>
      <div className="min-w-0">
        <div className="text-[length:var(--text-base)] font-bold text-[var(--foreground)] leading-tight">{value}</div>
        <div className="text-[length:var(--text-2xs)] text-[var(--muted-foreground)] truncate">{label}</div>
      </div>
    </Card>
  )
}