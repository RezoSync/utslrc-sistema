import { useEffect, useState, type ReactNode } from 'react'
import { STUDENTS, GROUPS } from '../data/students'
import { groupAverage, groupAttendance } from '../data/groups'
import { StatCard, Card, Table, Badge } from '../components/ui'
import { Icon } from '../components/Icon'
import type { IconName } from '../components/Icon'
import type { PageId, Role } from '../types'
import { classroomService, ApiError } from '../services'
import type { ClassroomFeedItem, ClassroomAssignmentStudentView } from '../services'

interface Props {
  onNavigate: (p: PageId) => void
  role: Role
  studentId?: string | null
  teacherId?: string | null
}

const STATUS_STYLE: Record<string, { bg: string; color: string }> = {
  Activo: { bg: 'var(--status-active-bg)', color: 'var(--status-active-fg)' },
  'Baja temporal': { bg: 'var(--status-hold-bg)', color: 'var(--status-hold-fg)' },
  Egresado: { bg: 'var(--status-graduated-bg)', color: 'var(--status-graduated-fg)' },
}

const TRABAJO_STATUS_STYLE: Record<string, { bg: string; color: string }> = {
  Entregado: { bg: 'var(--status-submitted-bg)', color: 'var(--status-submitted-fg)' },
  Pendiente: { bg: 'var(--status-pending-bg)', color: 'var(--status-pending-fg)' },
  Revisado: { bg: 'var(--status-reviewed-bg)', color: 'var(--status-reviewed-fg)' },
  'Con retraso': { bg: 'var(--status-late-bg)', color: 'var(--status-late-fg)' },
}

// Cada renglón de actividad recibe un tinte distinto tomado de tokens que
// ya existen en el sistema (secondary / gold-light / status-*), en vez de
// repetir el mismo fondo cuatro veces — misma paleta, más jerarquía visual.
const ACTIVITY_ITEMS: { icon: IconName; title: string; detail: (n: number) => string; tint: string; fg: string }[] = [
  { icon: 'check', title: 'Calificaciones', detail: () => 'Parcial 1 listo para revisión', tint: 'var(--status-active-bg)', fg: 'var(--status-active-fg)' },
  { icon: 'calendar', title: 'Asistencia', detail: (n) => `${n} grupos actualizados`, tint: 'var(--status-graduated-bg)', fg: 'var(--status-graduated-fg)' },
  { icon: 'library', title: 'Biblioteca', detail: () => 'Préstamos próximos a vencer', tint: 'var(--gold-light)', fg: '#92660e' },
  { icon: 'service', title: 'Servicios', detail: () => 'Solicitudes pendientes de atención', tint: 'var(--secondary)', fg: 'var(--secondary-foreground)' },
]

function fmtDate(iso: string | null) {
  if (!iso) return ''
  return new Date(iso).toLocaleDateString('es-MX', { day: '2-digit', month: 'short' })
}

function daysUntil(iso: string | null) {
  if (!iso) return null
  const ms = new Date(iso).setHours(0, 0, 0, 0) - new Date().setHours(0, 0, 0, 0)
  return Math.round(ms / 86400000)
}

function greeting() {
  const h = new Date().getHours()
  if (h < 12) return 'Buenos días'
  if (h < 19) return 'Buenas tardes'
  return 'Buenas noches'
}

function SecondaryButton({ onClick, children, ariaLabel }: { onClick: () => void; children: ReactNode; ariaLabel?: string }) {
  return (
    <button
      onClick={onClick}
      aria-label={ariaLabel}
      className="min-h-[44px] rounded-[9px] border border-[var(--border)] bg-white px-3.5 py-2 text-[length:var(--text-xs)] font-bold cursor-pointer transition-colors hover:bg-[var(--secondary)] hover:border-[var(--primary)]"
    >
      {children}
    </button>
  )
}

function initials(name: string) {
  const parts = name.trim().split(/\s+/)
  return ((parts[0]?.[0] ?? '') + (parts[1]?.[0] ?? '')).toUpperCase()
}

function Avatar({ name }: { name: string }) {
  return (
    <div
      aria-hidden="true"
      className="grid place-items-center w-8 h-8 rounded-full text-[length:var(--text-2xs)] font-extrabold shrink-0"
      style={{ background: 'var(--secondary)', color: 'var(--primary-dark)' }}
    >
      {initials(name)}
    </div>
  )
}

export default function Dashboard({ onNavigate, role, studentId }: Props) {
  if (role === 'Alumno') return <StudentDashboard onNavigate={onNavigate} studentId={studentId} />

  const promedio = STUDENTS.reduce((a, s) => a + s.promedio, 0) / STUDENTS.length
  const asistencia = Math.round(STUDENTS.reduce((a, s) => a + s.asistencia, 0) / STUDENTS.length)
  const groupAverages = GROUPS.map((g) => ({ g, v: groupAverage(g) }))
  const bestGroup = groupAverages.reduce((best, cur) => (cur.v > best.v ? cur : best), groupAverages[0])

  return (
    <div className="flex flex-col gap-5 p-6">
      <div>
        <h1 className="m-0 text-[length:var(--text-lg)]">Resumen académico</h1>
        <p className="mt-1.5 mb-0 text-[length:var(--text-sm)] text-[var(--muted-foreground)]">
          Visión general del periodo Enero – Abril 2025.
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3.5">
        <StatCard label="Alumnos" value={STUDENTS.length} icon="◍" tint="var(--secondary)" />
        <StatCard label="Grupos" value={GROUPS.length} icon="◫" tint="var(--gold-light)" />
        <StatCard label="Promedio general" value={promedio.toFixed(1)} icon="◔" tint="#eff6ff" />
        <StatCard label="Asistencia" value={`${asistencia}%`} icon="◷" tint="#f0faf4" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-[1.4fr_0.8fr] gap-4">
        <Card>
          <div className="flex justify-between items-baseline mb-4 gap-3 flex-wrap">
            <h2 className="m-0 text-[length:var(--text-base)]">Desempeño por grupo</h2>
            {groupAverages.length > 0 && (
              <span className="text-[length:var(--text-2xs)] text-[var(--muted-foreground)]">
                Mejor grupo: <b className="text-[var(--primary-dark)]">{bestGroup.g.replace('IDGS ', '')}</b> · {bestGroup.v.toFixed(1)}
              </span>
            )}
          </div>
          <div
            className="relative flex items-end gap-5 h-[220px] px-1.5 pt-3 border-b border-[#dfe9e5]"
            style={{ backgroundImage: 'repeating-linear-gradient(to bottom, transparent 0, transparent 43px, #edf3f0 44px)' }}
            role="img"
            aria-label={`Promedio por grupo: ${groupAverages.map(({ g, v }) => `${g} ${v.toFixed(1)}`).join(', ')}`}
          >
            {/* Línea de referencia con el promedio general del plantel, para
                que cada barra se lea en contexto y no solo en aislado. */}
            <div
              className="absolute left-0 right-0 border-t border-dashed"
              style={{ bottom: `${Math.max(12, Math.min(96, promedio * 10))}%`, borderColor: 'var(--gold)' }}
              aria-hidden="true"
            />
            {groupAverages.map(({ g, v }) => {
              const aboveAvg = v >= promedio
              return (
                <div key={g} className="flex-1 h-full flex flex-col items-center gap-1.5" aria-hidden="true">
                  <b className="text-[length:var(--text-xs)] text-[var(--primary-dark)]">{v.toFixed(1)}</b>
                  <div className="flex-1 w-full flex justify-center items-end">
                    <div
                      className="w-full max-w-[58px] rounded-t-[9px] rounded-b-[3px] transition-[height] duration-500"
                      title={`${g}: promedio ${v.toFixed(1)}`}
                      style={{
                        height: `${Math.max(12, Math.min(100, v * 10))}%`,
                        background: aboveAvg
                          ? 'linear-gradient(180deg,var(--primary),#72d2bd)'
                          : 'linear-gradient(180deg,#d7a73a,#f2cf85)',
                        boxShadow: aboveAvg ? '0 7px 14px rgba(25,183,124,.18)' : '0 7px 14px rgba(215,167,58,.18)',
                      }}
                    />
                  </div>
                  <span className="pb-2 text-[length:var(--text-2xs)] text-[var(--muted-foreground)]">{g.replace('IDGS ', '')}</span>
                </div>
              )
            })}
          </div>
          <div className="flex items-center gap-4 mt-3 text-[length:var(--text-2xs)] text-[var(--muted-foreground)]">
            <span className="flex items-center gap-1.5"><i className="inline-block w-2.5 h-2.5 rounded-[3px]" style={{ background: 'var(--primary)' }} />En o sobre el promedio</span>
            <span className="flex items-center gap-1.5"><i className="inline-block w-2.5 h-2.5 rounded-[3px]" style={{ background: 'var(--gold)' }} />Debajo del promedio</span>
            <span className="flex items-center gap-1.5"><i className="inline-block w-3.5 h-0 border-t border-dashed" style={{ borderColor: 'var(--gold)' }} />Promedio general</span>
          </div>
        </Card>
        <Card>
          <h2 className="m-0 mb-4 text-[length:var(--text-base)]">Actividad reciente</h2>
          <div className="grid gap-2.5">
            {ACTIVITY_ITEMS.map((item) => (
              <div key={item.title} className="flex gap-3 items-center p-2.5 border border-[#eef1f3] rounded-[11px] transition-colors hover:border-[var(--border)] hover:bg-[var(--muted)]">
                <div className="grid place-items-center w-[34px] h-[34px] rounded-[10px] shrink-0" style={{ background: item.tint, color: item.fg }} aria-hidden="true">
                  <Icon name={item.icon} size={16} />
                </div>
                <div className="min-w-0">
                  <b className="block text-[length:var(--text-xs)]">{item.title}</b>
                  <span className="text-[length:var(--text-2xs)] text-[var(--muted-foreground)]">{item.detail(GROUPS.length)}</span>
                </div>
              </div>
            ))}
          </div>
        </Card>
      </div>

      <Card>
        <div className="flex justify-between items-center mb-3.5">
          <h2 className="m-0 text-[length:var(--text-base)]">Alumnos recientes</h2>
          <SecondaryButton onClick={() => onNavigate('alumnos')} ariaLabel="Ver todos los alumnos">
            Ver todos
          </SecondaryButton>
        </div>
        <Table headers={['Expediente', 'Nombre', 'Grupo', 'Promedio', 'Status']}>
          {STUDENTS.slice(0, 8).map((s) => (
            <tr key={s.id} className="border-b border-[var(--border)] transition-colors hover:bg-[var(--muted)]">
              <td className="px-3 py-2.5 font-mono text-[length:var(--text-xs)] text-[var(--muted-foreground)]">{s.expediente}</td>
              <td className="px-3 py-2.5 font-medium">
                <div className="flex items-center gap-2.5">
                  <Avatar name={s.nombre} />
                  {s.nombre}
                </div>
              </td>
              <td className="px-3 py-2.5 text-[var(--muted-foreground)]">{s.grupo}</td>
              <td className="px-3 py-2.5 font-semibold">{s.promedio.toFixed(1)}</td>
              <td className="px-3 py-2.5">
                <Badge text={s.status} bg={STATUS_STYLE[s.status].bg} color={STATUS_STYLE[s.status].color} />
              </td>
            </tr>
          ))}
        </Table>
      </Card>
    </div>
  )
}

function StudentDashboard({ onNavigate, studentId }: { onNavigate: (p: PageId) => void; studentId?: string | null }) {
  const student = STUDENTS.find((s) => s.id === studentId)
  const [feed, setFeed] = useState<ClassroomFeedItem[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    if (!student) {
      setLoading(false)
      return
    }
    classroomService
      .feed(student.grupo)
      .then(setFeed)
      .catch((e) => setError(e instanceof ApiError ? e.message : 'No se pudo cargar la actividad de tu grupo.'))
      .finally(() => setLoading(false))
  }, [student?.grupo])

  if (!student) {
    return (
      <div className="p-6">
        <Card>
          <p className="m-0 text-[length:var(--text-sm)] text-[var(--muted-foreground)]">No se encontró tu expediente de alumno.</p>
        </Card>
      </div>
    )
  }

  const trabajos = feed.filter((f): f is ClassroomAssignmentStudentView => f.kind === 'trabajo')
  const pendientes = trabajos.filter((t) => !t.miEntrega || t.miEntrega.status === 'Pendiente')
  const proximos = [...pendientes]
    .filter((t) => t.fecha_limite)
    .sort((a, b) => new Date(a.fecha_limite!).getTime() - new Date(b.fecha_limite!).getTime())
    .slice(0, 5)
  const actividad = [...feed].slice(0, 4)

  return (
    <div className="flex flex-col gap-5 p-6">
      <div className="flex items-start justify-between gap-3 flex-wrap">
        <div>
          <h1 className="m-0 text-[length:var(--text-lg)]">{greeting()}, {student.nombre.split(' ')[0]}</h1>
          <p className="mt-1.5 mb-0 text-[length:var(--text-sm)] text-[var(--muted-foreground)]">
            {student.grupo} · {student.carrera} · Cuatrimestre {student.cuatrimestre}
          </p>
        </div>
        <Badge text={student.status} bg={STATUS_STYLE[student.status].bg} color={STATUS_STYLE[student.status].color} />
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3.5">
        <StatCard label="Mi promedio" value={student.promedio.toFixed(1)} icon="◔" tint="#eff6ff" />
        <StatCard label="Mi asistencia" value={`${student.asistencia}%`} icon="◷" tint="#f0faf4" />
        <StatCard label="Trabajos pendientes" value={pendientes.length} icon="◈" tint="var(--gold-light)" />
        <StatCard label="Anuncios" value={feed.filter((f) => f.kind === 'anuncio').length} icon="▥" tint="var(--secondary)" />
      </div>

      {error && (
        <div role="alert" className="rounded-[10px] px-3.5 py-2.5 text-[length:var(--text-xs)]" style={{ background: '#fdeeee', color: '#b42318' }}>
          {error}
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Card>
          <h2 className="m-0 mb-4 text-[length:var(--text-base)]">Mi grupo</h2>
          <div className="flex items-center gap-3 pb-4 mb-1 border-b border-[var(--border)]">
            <div className="grid place-items-center w-11 h-11 rounded-[12px] shrink-0" style={{ background: 'var(--secondary)', color: 'var(--primary-dark)' }} aria-hidden="true">
              <Icon name="student" size={22} />
            </div>
            <div>
              <b className="block text-[length:var(--text-base)]">{student.grupo}</b>
              <span className="text-[length:var(--text-xs)] text-[var(--muted-foreground)]">{student.carrera}</span>
            </div>
          </div>
          <div className="grid gap-0">
            <Row label="Cuatrimestre" value={student.cuatrimestre} />
            <Row label="Periodo" value={student.periodo} />
            <Row label="Promedio del grupo" value={groupAverage(student.grupo).toFixed(1)} />
            <Row label="Asistencia del grupo" value={`${Math.round(groupAttendance(student.grupo))}%`} last />
          </div>
        </Card>

        <Card>
          <div className="flex justify-between items-center mb-3.5">
            <h2 className="m-0 text-[length:var(--text-base)]">Actividad reciente</h2>
            <SecondaryButton onClick={() => onNavigate('plataforma-trabajos')} ariaLabel="Ver toda la actividad reciente">
              Ver todo
            </SecondaryButton>
          </div>
          <div aria-live="polite">
            {loading && <p className="m-0 text-[length:var(--text-xs)] text-[var(--muted-foreground)]">Cargando…</p>}
            {!loading && actividad.length === 0 && (
              <p className="m-0 text-[length:var(--text-xs)] text-[var(--muted-foreground)]">Sin anuncios ni trabajos todavía.</p>
            )}
            <div className="grid gap-2.5">
              {actividad.map((item) => {
                const isAnuncio = item.kind === 'anuncio'
                return (
                  <div key={item.id} className="flex gap-3 items-start p-2.5 border border-[#eef1f3] rounded-[11px] transition-colors hover:bg-[var(--muted)]">
                    <div
                      className="grid place-items-center shrink-0 w-[34px] h-[34px] rounded-[10px]"
                      style={{ background: isAnuncio ? 'var(--gold-light)' : 'var(--secondary)', color: isAnuncio ? '#92660e' : 'var(--primary-dark)' }}
                      aria-hidden="true"
                    >
                      <Icon name={isAnuncio ? 'send' : 'file'} size={16} />
                    </div>
                    <div className="min-w-0">
                      <b className="block text-[length:var(--text-xs)]">{item.titulo}</b>
                      <span className="text-[length:var(--text-2xs)] text-[var(--muted-foreground)]">
                        {item.docente}{item.materia ? ` · ${item.materia}` : ''}
                      </span>
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        </Card>
      </div>

      <Card>
        <div className="flex justify-between items-center mb-3.5">
          <h2 className="m-0 text-[length:var(--text-base)]">Mis próximos trabajos</h2>
          <SecondaryButton onClick={() => onNavigate('plataforma-trabajos')} ariaLabel="Ir a la plataforma de trabajos">
            Ir a Plataforma de Trabajos
          </SecondaryButton>
        </div>
        {!loading && proximos.length === 0 && (
          <p className="m-0 py-2.5 text-[length:var(--text-xs)] text-[var(--muted-foreground)]">No tienes trabajos pendientes por entregar.</p>
        )}
        {proximos.length > 0 && (
          <Table headers={['Trabajo', 'Materia', 'Tipo', 'Fecha límite', 'Estado']}>
            {proximos.map((t) => {
              const d = daysUntil(t.fecha_limite)
              const urgent = d !== null && d <= 2
              return (
                <tr key={t.id} className="border-b border-[var(--border)]">
                  <td className="px-3 py-2.5 font-medium">{t.titulo}</td>
                  <td className="px-3 py-2.5 text-[var(--muted-foreground)]">{t.materia ?? '—'}</td>
                  <td className="px-3 py-2.5 text-[var(--muted-foreground)]">{t.tipo}</td>
                  <td className="px-3 py-2.5 font-medium" style={urgent ? { color: 'var(--status-late-fg)' } : undefined}>
                    {fmtDate(t.fecha_limite)}
                  </td>
                  <td className="px-3 py-2.5">
                    <Badge
                      text={t.miEntrega?.status ?? 'Pendiente'}
                      bg={TRABAJO_STATUS_STYLE[t.miEntrega?.status ?? 'Pendiente'].bg}
                      color={TRABAJO_STATUS_STYLE[t.miEntrega?.status ?? 'Pendiente'].color}
                    />
                  </td>
                </tr>
              )
            })}
          </Table>
        )}
      </Card>
    </div>
  )
}

function Row({ label, value, last }: { label: string; value: string; last?: boolean }) {
  return (
    <div className={`flex justify-between py-2 text-[length:var(--text-sm)] ${last ? '' : 'border-b border-[var(--border)]'}`}>
      <span className="text-[var(--muted-foreground)]">{label}</span>
      <span className="font-medium">{value}</span>
    </div>
  )
}