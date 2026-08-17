import { useEffect, useState } from 'react'
import { STUDENTS } from '../data/students'
import { TEACHERS } from '../data/teachers'
import { GROUPS_DATA } from '../data/groups'
import { Card, StatCard, Badge, Button, Select, Modal, EmptyState } from '../components/ui'
import { Icon } from '../components/Icon'
import aulaBanner from '../assets/oferta-virtual.png'
import { classroomService, subjectService, ApiError } from '../services'
import type {
  ClassroomAttachment,
  ClassroomFeedItem,
  ClassroomAssignmentStudentView,
  ClassroomAssignmentTeacherView,
  Submission,
} from '../services'
import type { Role } from '../types'
import type { SubCrumb } from '../App'

interface Props {
  role?: Role
  studentId?: string | null
  teacherId?: string | null
  onSubCrumbChange?: (crumb: SubCrumb | null) => void
}

interface SubjectOption {
  id: string
  nombre: string
  docente_nombre?: string | null
  creditos?: number
}

const STATUS_STYLE: Record<string, { bg: string; color: string }> = {
  Entregado: { bg: '#eff6ff', color: '#1d4ed8' },
  Pendiente: { bg: '#f4f4f5', color: '#52525b' },
  Revisado: { bg: '#f0faf4', color: '#15803d' },
  'Con retraso': { bg: '#fef2f2', color: '#b91c1c' },
}

const TIPO_ICON: Record<string, string> = {
  Tarea: '▤',
  Proyecto: '▦',
  Exposición: '◔',
  Investigación: '◈',
}

// Materia especial para anuncios/trabajos que se publicaron sin ligarlos a
// ninguna materia — no es un id real de la tabla `subjects`, sólo la llave
// que usamos en el front para agruparlos en su propia tarjeta "General".
const GENERAL_KEY = '__general__'

// Límites de caracteres — deben coincidir con TITLE_MAX/TEXT_MAX en el backend
// (backend/src/routes/classroom.js), que valida lo mismo del lado del servidor.
const TITLE_MAX = 60
const TEXT_MAX = 600

// Adjuntos permitidos — deben coincidir con ALLOWED_MIME en el backend.
const MAX_FILES = 5
const MAX_FILE_SIZE = 25 * 1024 * 1024 // 25MB
const ACCEPTED_MIME = [
  'application/pdf',
  'application/vnd.ms-powerpoint',
  'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'image/jpeg',
  'image/png',
  'image/webp',
  'image/gif',
]
const ACCEPTED_EXT = '.pdf,.ppt,.pptx,.jpg,.jpeg,.png,.webp,.gif'

function fmtDate(iso: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  return d.toLocaleDateString('es-MX', { day: '2-digit', month: 'short', year: 'numeric' })
}

function fmtDateTime(iso: string | null) {
  if (!iso) return ''
  return new Date(iso).toLocaleString('es-MX', { day: '2-digit', month: 'short', hour: '2-digit', minute: '2-digit' })
}

function formatBytes(n: number | null | undefined) {
  if (n === null || n === undefined) return ''
  if (n < 1024) return `${n} B`
  if (n < 1024 * 1024) return `${(n / 1024).toFixed(0)} KB`
  return `${(n / (1024 * 1024)).toFixed(1)} MB`
}

/** Valida un conjunto de archivos antes de intentar subirlos: mismo tipo/tamaño/cantidad que exige el backend. */
function validateFiles(list: File[]): string {
  if (list.length > MAX_FILES) return `Puedes adjuntar máximo ${MAX_FILES} archivos.`
  for (const f of list) {
    if (!ACCEPTED_MIME.includes(f.type)) return `"${f.name}" no es un tipo permitido. Solo PDF, PowerPoint o imágenes.`
    if (f.size > MAX_FILE_SIZE) return `"${f.name}" pesa más de 25MB.`
  }
  return ''
}

// Descarga legada: entregas guardadas antes de que existiera la tabla de
// adjuntos múltiples, que sólo tienen un archivo en archivo_nombre/archivo_ruta.
async function triggerLegacyDownload(submissionId: string, filename: string) {
  try {
    const blob = await classroomService.download(submissionId)
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = filename
    document.body.appendChild(a)
    a.click()
    a.remove()
    URL.revokeObjectURL(url)
  } catch (err) {
    alert(err instanceof ApiError ? err.message : 'No se pudo descargar el archivo.')
  }
}

/** A qué "buzón" pertenece un trabajo para el alumno: sin entregar (en tiempo),
 * sin entregar (ya venció la fecha límite), o ya entregado (a tiempo, tarde o revisado). */
type Bucket = 'pendientes' | 'vencidas' | 'entregadas'

function bucketOf(t: ClassroomAssignmentStudentView): Bucket {
  const status = t.miEntrega?.status ?? 'Pendiente'
  if (status !== 'Pendiente') return 'entregadas'
  const today = new Date().toISOString().slice(0, 10)
  if (t.fecha_limite && t.fecha_limite < today) return 'vencidas'
  return 'pendientes'
}

const BUCKET_LABEL: Record<Bucket, string> = {
  pendientes: 'Actividades pendientes',
  vencidas: 'No entregadas (vencidas)',
  entregadas: 'Actividades entregadas',
}

/** Contador de caracteres restantes, con aviso visual al acercarse o pasarse del límite. */
function CharCounter({ length, max }: { length: number; max: number }) {
  const remaining = max - length
  const over = remaining < 0
  const near = !over && remaining <= Math.max(5, max * 0.1)
  return (
    <span style={{ fontSize: 11, color: over ? '#b91c1c' : near ? '#c2410c' : 'var(--muted-foreground)', alignSelf: 'flex-end' }}>
      {over ? `${Math.abs(remaining)} caracteres de más` : `${remaining} caracteres restantes`}
    </span>
  )
}

/** Selector de archivos con validación propia de tipo/tamaño/cantidad y chips removibles. */
function FilePicker({ id, files, onChange }: { id: string; files: File[]; onChange: (files: File[]) => void }) {
  const [err, setErr] = useState('')

  const addFiles = (list: FileList | null) => {
    if (!list || list.length === 0) return
    const combined = [...files, ...Array.from(list)]
    const msg = validateFiles(combined)
    if (msg) {
      setErr(msg)
      return
    }
    setErr('')
    onChange(combined)
  }

  const remove = (idx: number) => {
    setErr('')
    onChange(files.filter((_, i) => i !== idx))
  }

  return (
    <div style={{ display: 'grid', gap: 8 }}>
      <label
        htmlFor={id}
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: 8,
          padding: '9px 12px',
          borderRadius: 7,
          border: '1px dashed var(--border)',
          fontSize: 12.5,
          color: 'var(--muted-foreground)',
          cursor: 'pointer',
        }}
      >
        <Icon name="file" size={15} />
        Adjuntar PDF, PowerPoint o imágenes (máx. {MAX_FILES}, 25MB c/u)
        <input
          id={id}
          type="file"
          multiple
          accept={ACCEPTED_EXT}
          style={{ display: 'none' }}
          onChange={(e) => {
            addFiles(e.target.files)
            e.target.value = ''
          }}
        />
      </label>
      {files.length > 0 && (
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
          {files.map((f, i) => (
            <span
              key={`${f.name}-${i}`}
              style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '5px 6px 5px 10px', borderRadius: 999, background: 'var(--muted)', fontSize: 11.5 }}
            >
              {f.name} · {formatBytes(f.size)}
              <button
                type="button"
                onClick={() => remove(i)}
                aria-label={`Quitar ${f.name}`}
                style={{ border: 0, background: 'transparent', cursor: 'pointer', color: 'var(--muted-foreground)', display: 'flex', padding: 2 }}
              >
                <Icon name="close" size={12} />
              </button>
            </span>
          ))}
        </div>
      )}
      {err && <span style={{ fontSize: 12, color: '#b42318' }}>{err}</span>}
    </div>
  )
}

/** Un adjunto ya publicado: nombre, tamaño y acciones para verlo (nueva pestaña) o descargarlo. */
function AttachmentChip({
  attachment,
  assignmentId,
  submissionId,
}: {
  attachment: ClassroomAttachment
  assignmentId?: string
  submissionId?: string
}) {
  const [busy, setBusy] = useState(false)

  const fetchBlob = () =>
    assignmentId
      ? classroomService.downloadAssignmentAttachment(assignmentId, attachment.id)
      : classroomService.downloadSubmissionAttachment(submissionId!, attachment.id)

  const open = async (mode: 'ver' | 'descargar') => {
    setBusy(true)
    try {
      const blob = await fetchBlob()
      const url = URL.createObjectURL(blob)
      if (mode === 'ver') {
        window.open(url, '_blank', 'noopener')
        setTimeout(() => URL.revokeObjectURL(url), 30000)
      } else {
        const a = document.createElement('a')
        a.href = url
        a.download = attachment.original_name
        document.body.appendChild(a)
        a.click()
        a.remove()
        URL.revokeObjectURL(url)
      }
    } catch (err) {
      alert(err instanceof ApiError ? err.message : 'No se pudo abrir el archivo.')
    } finally {
      setBusy(false)
    }
  }

  return (
    <span
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: 8,
        padding: '6px 10px',
        borderRadius: 999,
        border: '1px solid var(--border)',
        fontSize: 11.5,
        background: '#fff',
      }}
    >
      <Icon name="file" size={13} style={{ flexShrink: 0, color: 'var(--muted-foreground)' }} />
      <span style={{ maxWidth: 160, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', fontWeight: 600 }}>
        {attachment.original_name}
      </span>
      {attachment.size_bytes !== null && <span style={{ color: 'var(--muted-foreground)' }}>{formatBytes(attachment.size_bytes)}</span>}
      <button
        type="button"
        onClick={() => open('ver')}
        disabled={busy}
        style={{ border: 0, background: 'transparent', cursor: 'pointer', color: 'var(--primary-dark)', fontWeight: 700, fontSize: 11 }}
      >
        Ver
      </button>
      <button
        type="button"
        onClick={() => open('descargar')}
        disabled={busy}
        style={{ border: 0, background: 'transparent', cursor: 'pointer', color: 'var(--primary-dark)', fontWeight: 700, fontSize: 11 }}
      >
        Descargar
      </button>
    </span>
  )
}

function AttachmentList({
  items,
  assignmentId,
  submissionId,
  style,
}: {
  items: ClassroomAttachment[] | undefined
  assignmentId?: string
  submissionId?: string
  style?: React.CSSProperties
}) {
  if (!items || items.length === 0) return null
  return (
    <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, marginTop: 10, ...style }}>
      {items.map((a) => (
        <AttachmentChip key={a.id} attachment={a} assignmentId={assignmentId} submissionId={submissionId} />
      ))}
    </div>
  )
}

export default function PlataformaTrabajos({ role, studentId, teacherId, onSubCrumbChange }: Props) {
  const isTeacher = role === 'Docente'
  const isStudent = role === 'Alumno'
  // Administrador / Control Escolar: acceso de solo consulta a cualquier grupo
  // (el backend ya lo permite en /feed y /submissions; aquí sólo faltaba pintarlo).
  const isStaff = role === 'Administrador' || role === 'Control Escolar'

  const ownStudent = isStudent ? STUDENTS.find((s) => s.id === studentId) : undefined
  const teacherRecord = isTeacher ? TEACHERS.find((t) => t.id === teacherId) : undefined
  const teacherGroups = teacherRecord?.grupos ?? []
  const allGroups = isStaff ? GROUPS_DATA.map((g) => g.nombre) : []

  const [group, setGroup] = useState(isStudent ? ownStudent?.grupo ?? '' : isStaff ? allGroups[0] ?? '' : teacherGroups[0] ?? '')
  const [subjects, setSubjects] = useState<SubjectOption[]>([])
  const [feed, setFeed] = useState<ClassroomFeedItem[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const [showAnuncio, setShowAnuncio] = useState(false)
  const [showTrabajo, setShowTrabajo] = useState(false)
  const [reviewing, setReviewing] = useState<ClassroomAssignmentTeacherView | null>(null)
  const [submittingFor, setSubmittingFor] = useState<string | null>(null)

  // Sólo para el alumno: primero ve tarjetas de materias, y al entrar a una
  // ve el contenido de esa materia. Los 3 botones abren un modal con el
  // resumen de todas sus materias (por eso viven a nivel de grupo, no de materia).
  const [view, setView] = useState<'grid' | 'materia'>('grid')
  const [selectedMateria, setSelectedMateria] = useState<string>(GENERAL_KEY)
  const [classroomTab, setClassroomTab] = useState<'novedades' | 'trabajos' | 'personas'>('novedades')
  const [modalBucket, setModalBucket] = useState<Bucket | null>(null)

  // Reporta hacia App.tsx el nivel extra de breadcrumb ("Materia: X") cuando
  // el alumno entra a una materia, y lo limpia al volver a la cuadrícula o
  // al salir de esta página.
  useEffect(() => {
    if (!onSubCrumbChange) return
    if (isStudent && view === 'materia') {
      onSubCrumbChange({
        label: `Materia: ${selectedMateria === GENERAL_KEY ? 'General' : selectedMateria}`,
        onHome: () => setView('grid'),
      })
    } else {
      onSubCrumbChange(null)
    }
    return () => onSubCrumbChange(null)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [view, selectedMateria, isStudent])

  useEffect(() => {
    if (isStudent && ownStudent) setGroup(ownStudent.grupo)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isStudent, ownStudent?.grupo])

  async function loadFeed(g: string) {
    if (!g) return
    setLoading(true)
    setError('')
    try {
      const data = await classroomService.feed(g)
      setFeed(data)
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'No se pudo cargar la información del grupo.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    if (group) loadFeed(group)
    setView('grid')
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [group])

  useEffect(() => {
    if (!group) return
    subjectService
      .getByGroup(group)
      .then((rows) => {
        const list = rows as { id: string; nombre: string; teacher_id: string | null; docente_nombre: string | null; creditos: number }[]
        if (isTeacher && teacherId) {
          setSubjects(
            list
              .filter((r) => r.teacher_id === teacherId)
              .map((r) => ({ id: r.id, nombre: r.nombre, docente_nombre: r.docente_nombre, creditos: r.creditos }))
          )
        } else {
          setSubjects(list.map((r) => ({ id: r.id, nombre: r.nombre, docente_nombre: r.docente_nombre, creditos: r.creditos })))
        }
      })
      .catch(() => setSubjects([]))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [group, isTeacher, teacherId])

  const trabajos = feed.filter((f): f is ClassroomAssignmentStudentView | ClassroomAssignmentTeacherView => f.kind === 'trabajo')
  const anuncios = feed.filter((f) => f.kind === 'anuncio')
  const studentTrabajos = isStudent ? (trabajos as ClassroomAssignmentStudentView[]) : []

  const pendientesList = studentTrabajos.filter((t) => bucketOf(t) === 'pendientes')
  const vencidasList = studentTrabajos.filter((t) => bucketOf(t) === 'vencidas')
  const entregadasList = studentTrabajos.filter((t) => bucketOf(t) === 'entregadas')
  const bucketItems: Record<Bucket, ClassroomAssignmentStudentView[]> = {
    pendientes: pendientesList,
    vencidas: vencidasList,
    entregadas: entregadasList,
  }

  const sinEntregarPorMateria = new Map<string, number>()
  for (const t of studentTrabajos) {
    if (bucketOf(t) === 'entregadas') continue
    const key = t.materia ?? GENERAL_KEY
    sinEntregarPorMateria.set(key, (sinEntregarPorMateria.get(key) ?? 0) + 1)
  }

  // Para el docente: cuántas entregas de cada materia siguen sin revisar
  // (ya entregadas o con retraso, pero aún no calificadas).
  const teacherTrabajos = isTeacher ? (trabajos as ClassroomAssignmentTeacherView[]) : []
  const sinRevisarPorMateria = new Map<string, number>()
  for (const t of teacherTrabajos) {
    const sinRevisar = t.resumenEntregas.Entregado + t.resumenEntregas['Con retraso']
    if (sinRevisar <= 0) continue
    const key = t.materia ?? GENERAL_KEY
    sinRevisarPorMateria.set(key, (sinRevisarPorMateria.get(key) ?? 0) + sinRevisar)
  }
  const hasGeneral = feed.some((f) => f.materia === null)

  const materiaFeed = feed.filter((f) => (selectedMateria === GENERAL_KEY ? f.materia === null : f.materia === selectedMateria))
  const selectedSubject = subjects.find((subject) => subject.nombre === selectedMateria)
  const classroomAssignments = materiaFeed.filter((item): item is ClassroomAssignmentStudentView => item.kind === 'trabajo')
  const classroomAnnouncements = materiaFeed.filter((item) => item.kind === 'anuncio')
  const classmates = STUDENTS.filter((student) => student.grupo === group)

  function openMateria(materia: string | null) {
    setSelectedMateria(materia ?? GENERAL_KEY)
    setClassroomTab('novedades')
    setView('materia')
    setModalBucket(null)
  }

  const entregasTotales = isTeacher || isStaff
    ? (trabajos as ClassroomAssignmentTeacherView[]).reduce((s, t) => s + t.resumenEntregas.total, 0)
    : 0
  const entregadas = isTeacher || isStaff
    ? (trabajos as ClassroomAssignmentTeacherView[]).reduce(
        (s, t) => s + t.resumenEntregas.Entregado + t.resumenEntregas['Con retraso'] + t.resumenEntregas.Revisado,
        0
      )
    : 0

  const errorBanner = error && (
    <div style={{ padding: '10px 14px', borderRadius: 10, background: '#fdeeee', color: '#b42318', fontSize: 12.5 }}>{error}</div>
  )

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: 12 }}>
        <div>
          <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>
            {isStudent
              ? view === 'grid'
                ? `Elige una materia de ${group || 'tu grupo'} para ver sus anuncios y trabajos.`
                : ''
              : isStaff
              ? 'Consulta de anuncios y trabajos publicados por grupo (solo lectura).'
              : 'Anuncios y trabajos publicados por grupo.'}
          </p>
        </div>
        <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
          {isTeacher && teacherGroups.length > 1 && <Select value={group} onChange={setGroup} options={teacherGroups} />}
          {isStaff && allGroups.length > 1 && <Select value={group} onChange={setGroup} options={allGroups} />}
          {isTeacher && (
            <>
              <Button variant="secondary" small onClick={() => setShowAnuncio(true)}>
                + Anuncio
              </Button>
              <Button variant="primary" small onClick={() => setShowTrabajo(true)}>
                + Trabajo
              </Button>
            </>
          )}
        </div>
      </div>

      {(isTeacher || isStaff) && (
        <div className="rg-4" style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 14 }}>
          <StatCard label="Trabajos publicados" value={trabajos.length} icon="▦" tint="var(--secondary)" />
          <StatCard label="Anuncios" value={anuncios.length} icon="▥" tint="var(--gold-light)" />
          <StatCard label="Entregas recibidas" value={`${entregadas}/${entregasTotales}`} icon="✓" tint="#f0faf4" />
        </div>
      )}

      {errorBanner}

      {!group && (
        <Card>
          <p style={{ fontSize: 13, color: 'var(--muted-foreground)', textAlign: 'center', margin: 0, padding: '20px 0' }}>
            {isTeacher ? 'No tienes grupos asignados todavía.' : isStaff ? 'No hay grupos registrados todavía.' : 'No se encontró tu grupo.'}
          </p>
        </Card>
      )}

      {loading && <Card><p style={{ fontSize: 13, color: 'var(--muted-foreground)', textAlign: 'center', margin: 0 }}>Cargando…</p></Card>}

      {/* --------------------------- Vista de materias (alumno y docente) --------------------------- */}
      {(isStudent || isTeacher) && group && !loading && view === 'grid' && (
        <>
          {isStudent && (
            <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
              <SummaryButton icon="target" label="Pendientes" count={pendientesList.length} onClick={() => setModalBucket('pendientes')} />
              <SummaryButton icon="calendar" label="No entregadas (vencidas)" count={vencidasList.length} tone="danger" onClick={() => setModalBucket('vencidas')} />
              <SummaryButton icon="check" label="Entregadas" count={entregadasList.length} tone="success" onClick={() => setModalBucket('entregadas')} />
            </div>
          )}

          {subjects.length === 0 && !hasGeneral ? (
            <Card>
              <p style={{ fontSize: 13, color: 'var(--muted-foreground)', textAlign: 'center', margin: 0, padding: '20px 0' }}>
                {isTeacher ? 'No tienes materias registradas en este grupo.' : 'Aún no hay materias registradas para tu grupo.'}
              </p>
            </Card>
          ) : (
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(220px, 1fr))', gap: 14 }}>
              {subjects.map((s) => (
                <MateriaCard
                  key={s.id}
                  nombre={s.nombre}
                  docente={s.docente_nombre ?? undefined}
                  pendientes={isTeacher ? sinRevisarPorMateria.get(s.nombre) ?? 0 : sinEntregarPorMateria.get(s.nombre) ?? 0}
                  badgeSuffix={isTeacher ? 'por revisar' : 'sin entregar'}
                  onClick={() => openMateria(s.nombre)}
                />
              ))}
              {hasGeneral && (
                <MateriaCard
                  nombre="General"
                  docente="Anuncios y trabajos sin materia asignada"
                  pendientes={isTeacher ? sinRevisarPorMateria.get(GENERAL_KEY) ?? 0 : sinEntregarPorMateria.get(GENERAL_KEY) ?? 0}
                  badgeSuffix={isTeacher ? 'por revisar' : 'sin entregar'}
                  onClick={() => openMateria(null)}
                />
              )}
            </div>
          )}
        </>
      )}

      {(isStudent || isTeacher) && group && view === 'materia' && (
        <>
          <button
            onClick={() => setView('grid')}
            style={{ display: 'flex', alignItems: 'center', gap: 6, alignSelf: 'flex-start', border: 0, background: 'transparent', color: 'var(--primary-dark)', fontWeight: 700, fontSize: 13, cursor: 'pointer', padding: 0 }}
          >
            ← {isTeacher ? 'Todas tus materias' : 'Todas mis materias'}
          </button>
          <section className="classroom-shell">
            <div className="classroom-banner" style={{ backgroundImage: `linear-gradient(105deg, rgba(12, 76, 61, .94), rgba(25, 183, 124, .72)), url(${aulaBanner})` }}>
              <span>{group}</span>
              <h2>{selectedMateria === GENERAL_KEY ? 'General' : selectedMateria}</h2>
              <p>{selectedSubject?.docente_nombre ?? 'Aula virtual UTSLRC'}</p>
              {isTeacher && (
                <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
                  <Button variant="secondary" small onClick={() => setShowAnuncio(true)}>
                    + Anuncio
                  </Button>
                  <Button variant="primary" small onClick={() => setShowTrabajo(true)}>
                    + Trabajo
                  </Button>
                </div>
              )}
            </div>
            <div className="classroom-tabs" role="tablist" aria-label="Secciones del aula">
              {([
                ['novedades', 'Novedades'],
                ['trabajos', 'Trabajos'],
                ['personas', 'Personas'],
              ] as const).map(([id, label]) => (
                <button key={id} role="tab" aria-selected={classroomTab === id} className={classroomTab === id ? 'is-active' : ''} onClick={() => setClassroomTab(id)}>{label}</button>
              ))}
            </div>

            {classroomTab === 'novedades' && (
              <div className="classroom-content-grid">
                <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
                  <h3 style={{ margin: '0 0 2px', fontSize: 20 }}>Próximas</h3>
                  {classroomAssignments.length === 0 ? (
                    <Card>
                      <EmptyState
                        title="Sin actividades próximas"
                        subtitle={isTeacher ? 'Publica una tarea con el botón "+ Trabajo" para que aparezca aquí.' : 'Cuando tu docente publique una tarea aparecerá aquí.'}
                      />
                    </Card>
                  ) : (
                    classroomAssignments.map((item) => (
                      <FeedItemCard
                        key={item.id}
                        item={item}
                        isTeacher={isTeacher}
                        isStudent={isStudent}
                        onReview={() => setReviewing(item as unknown as ClassroomAssignmentTeacherView)}
                        submitting={submittingFor === item.id}
                        onOpenSubmit={() => setSubmittingFor(item.id)}
                        onCloseSubmit={() => setSubmittingFor(null)}
                        onSubmitted={() => { setSubmittingFor(null); loadFeed(group) }}
                      />
                    ))
                  )}
                </div>
                <aside className="classroom-announcements">
                  <h3 style={{ margin: '0 0 10px', fontSize: 17 }}>Anuncios</h3>
                  {classroomAnnouncements.length === 0 ? (
                    <Card><p style={{ margin: 0, fontSize: 12.5, color: 'var(--muted-foreground)' }}>No hay anuncios nuevos.</p></Card>
                  ) : (
                    classroomAnnouncements.map((item) => <FeedItemCard key={item.id} item={item} isTeacher={false} isStudent={false} submitting={false} onOpenSubmit={() => undefined} onCloseSubmit={() => undefined} onSubmitted={() => undefined} />)
                  )}
                </aside>
              </div>
            )}

            {classroomTab === 'trabajos' && (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 14, paddingTop: 18 }}>
                {classroomAssignments.length === 0 ? (
                  <Card>
                    <EmptyState
                      title="Sin trabajos publicados"
                      subtitle={isTeacher ? 'Publica una tarea con el botón "+ Trabajo" para que aparezca en esta pestaña.' : 'Cuando tu docente publique una actividad aparecerá en esta pestaña.'}
                    />
                  </Card>
                ) : (
                  classroomAssignments.map((item) => (
                    <FeedItemCard
                      key={item.id}
                      item={item}
                      isTeacher={isTeacher}
                      isStudent={isStudent}
                      onReview={() => setReviewing(item as unknown as ClassroomAssignmentTeacherView)}
                      submitting={submittingFor === item.id}
                      onOpenSubmit={() => setSubmittingFor(item.id)}
                      onCloseSubmit={() => setSubmittingFor(null)}
                      onSubmitted={() => { setSubmittingFor(null); loadFeed(group) }}
                    />
                  ))
                )}
              </div>
            )}

            {classroomTab === 'personas' && (
              <div className="classroom-people">
                <Card style={{ alignSelf: 'start', padding: 16 }}><span className="classroom-person-label">Docente</span><div className="classroom-person"><div className="classroom-avatar">{(selectedSubject?.docente_nombre ?? 'UT').slice(0, 2).toUpperCase()}</div><b>{selectedSubject?.docente_nombre ?? 'Docente de la materia'}</b></div></Card>
                <Card><span className="classroom-person-label">{isTeacher ? 'Alumnos' : 'Compañeros'} · {classmates.length}</span><div className="classroom-people-list">{classmates.map((student) => <div key={student.id} className="classroom-person"><div className="classroom-avatar">{student.nombre.split(' ').slice(0, 2).map((part) => part[0]).join('')}</div><span>{student.nombre}</span></div>)}</div></Card>
              </div>
            )}
          </section>
        </>
      )}

      {/* --------------------------- Vista plana de sólo lectura para staff --------------------------- */}
      {isStaff && (
        <>
          {!loading && group && feed.length === 0 && !error && (
            <Card>
              <p style={{ fontSize: 13, color: 'var(--muted-foreground)', textAlign: 'center', margin: 0, padding: '20px 0' }}>
                Aún no hay anuncios ni trabajos publicados en este grupo.
              </p>
            </Card>
          )}

          <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
            {feed.map((item) => (
              <FeedItemCard key={item.id} item={item} isTeacher isStudent={false} onReview={() => setReviewing(item as ClassroomAssignmentTeacherView)} />
            ))}
          </div>
        </>
      )}

      {showAnuncio && (
        <NuevoAnuncioModal
          group={group}
          subjects={subjects}
          onClose={() => setShowAnuncio(false)}
          onCreated={() => {
            setShowAnuncio(false)
            loadFeed(group)
          }}
        />
      )}

      {showTrabajo && (
        <NuevoTrabajoModal
          group={group}
          subjects={subjects}
          onClose={() => setShowTrabajo(false)}
          onCreated={() => {
            setShowTrabajo(false)
            loadFeed(group)
          }}
        />
      )}

      {reviewing && (
        <RevisarEntregasModal item={reviewing} readOnly={isStaff} onClose={() => setReviewing(null)} onChanged={() => loadFeed(group)} />
      )}

      {modalBucket && (
        <ActividadesModal
          title={BUCKET_LABEL[modalBucket]}
          items={bucketItems[modalBucket]}
          onClose={() => setModalBucket(null)}
          onSelectMateria={openMateria}
        />
      )}
    </div>
  )
}

/** Tarjeta de una materia en la vista inicial (alumno y docente). */
function MateriaCard({
  nombre,
  docente,
  pendientes,
  badgeSuffix = 'sin entregar',
  onClick,
}: {
  nombre: string
  docente?: string
  pendientes: number
  badgeSuffix?: string
  onClick: () => void
}) {
  return (
    <button
      onClick={onClick}
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'flex-start',
        gap: 10,
        textAlign: 'left',
        cursor: 'pointer',
        background: 'var(--card)',
        border: '1px solid var(--border)',
        borderRadius: 'var(--radius)',
        padding: 18,
      }}
    >
      <div style={{ display: 'flex', width: '100%', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <div style={{ width: 40, height: 40, borderRadius: 10, background: 'var(--secondary)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <Icon name="book" size={19} style={{ color: 'var(--primary-dark)' }} />
        </div>
        {pendientes > 0 && <Badge text={`${pendientes} ${badgeSuffix}`} bg="var(--gold-light)" color="#92660a" />}
      </div>
      <div>
        <h3 style={{ fontSize: 14.5, margin: '2px 0 4px', color: 'var(--foreground)' }}>{nombre}</h3>
        <p style={{ fontSize: 12, color: 'var(--muted-foreground)', margin: 0 }}>{docente || 'Sin docente asignado'}</p>
      </div>
    </button>
  )
}

/** Botón-resumen que abre el modal de un bucket (pendientes / vencidas / entregadas). */
function SummaryButton({
  icon,
  label,
  count,
  tone,
  onClick,
}: {
  icon: 'target' | 'calendar' | 'check'
  label: string
  count: number
  tone?: 'danger' | 'success'
  onClick: () => void
}) {
  const color = tone === 'danger' ? '#b91c1c' : tone === 'success' ? '#15803d' : 'var(--primary-dark)'
  const bg = tone === 'danger' ? '#fef2f2' : tone === 'success' ? '#f0faf4' : 'var(--secondary)'
  return (
    <button
      onClick={onClick}
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: 10,
        padding: '10px 16px',
        borderRadius: 'var(--radius)',
        border: '1px solid var(--border)',
        background: '#fff',
        cursor: 'pointer',
      }}
    >
      <div style={{ width: 34, height: 34, borderRadius: 9, background: bg, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
        <Icon name={icon} size={16} style={{ color }} />
      </div>
      <div style={{ textAlign: 'left' }}>
        <div style={{ fontSize: 17, fontWeight: 700, lineHeight: 1.1 }}>{count}</div>
        <div style={{ fontSize: 11.5, color: 'var(--muted-foreground)' }}>{label}</div>
      </div>
    </button>
  )
}

/** Modal con la lista de trabajos de uno de los 3 buckets, cruzando todas las materias del grupo. */
function ActividadesModal({
  title,
  items,
  onClose,
  onSelectMateria,
}: {
  title: string
  items: ClassroomAssignmentStudentView[]
  onClose: () => void
  onSelectMateria: (materia: string | null) => void
}) {
  return (
    <Modal title={title} onClose={onClose} width={640}>
      {items.length === 0 ? (
        <EmptyState title="Nada por aquí" subtitle="No tienes actividades en esta categoría por ahora." />
      ) : (
        <div style={{ display: 'grid', gap: 8 }}>
          {items.map((t) => (
            <button
              key={t.id}
              onClick={() => onSelectMateria(t.materia)}
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                gap: 10,
                padding: '10px 12px',
                borderRadius: 10,
                border: '1px solid var(--border)',
                background: '#fff',
                textAlign: 'left',
                cursor: 'pointer',
              }}
            >
              <div style={{ minWidth: 0 }}>
                <div style={{ fontSize: 13, fontWeight: 700 }}>{TIPO_ICON[t.tipo] ?? '▤'} {t.titulo}</div>
                <div style={{ fontSize: 11.5, color: 'var(--muted-foreground)', marginTop: 2 }}>{t.materia ?? 'General'} · {t.docente}</div>
              </div>
              {t.fecha_limite && <Badge text={fmtDate(t.fecha_limite)} bg="var(--gold-light)" color="#92660a" />}
            </button>
          ))}
        </div>
      )}
    </Modal>
  )
}

/** Un anuncio o trabajo del feed, con las acciones que le tocan según el rol. */
function FeedItemCard({
  item,
  isTeacher,
  isStudent,
  onReview,
  submitting,
  onOpenSubmit,
  onCloseSubmit,
  onSubmitted,
}: {
  item: ClassroomFeedItem
  isTeacher: boolean
  isStudent: boolean
  onReview?: () => void
  submitting?: boolean
  onOpenSubmit?: () => void
  onCloseSubmit?: () => void
  onSubmitted?: () => void
}) {
  if (item.kind === 'anuncio') {
    return (
      <Card>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 12 }}>
          <div>
            <Badge text="Anuncio" bg="var(--gold-light)" color="#92660a" />
            <h3 style={{ fontSize: 15, margin: '10px 0 6px' }}>{item.titulo}</h3>
            <p style={{ fontSize: 13, color: 'var(--foreground)', lineHeight: 1.6, margin: 0, whiteSpace: 'pre-wrap' }}>{item.mensaje}</p>
            <p style={{ fontSize: 11.5, color: 'var(--muted-foreground)', marginTop: 10 }}>
              {item.docente}{item.materia ? ` · ${item.materia}` : ''} · {fmtDateTime(item.created_at)}
            </p>
          </div>
        </div>
      </Card>
    )
  }

  return (
    <Card>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 12 }}>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 4 }}>
            {TIPO_ICON[item.tipo] ?? '▤'} {item.titulo}
          </div>
          <div style={{ fontSize: 12, color: 'var(--muted-foreground)' }}>
            {item.docente}{item.materia ? ` · ${item.materia}` : ''} · {item.tipo}
          </div>
          {item.descripcion && (
            <p style={{ fontSize: 13, color: 'var(--foreground)', lineHeight: 1.6, margin: '10px 0 0', whiteSpace: 'pre-wrap' }}>
              {item.descripcion}
            </p>
          )}
          <AttachmentList items={item.adjuntos} assignmentId={item.id} />
        </div>
        {item.fecha_limite && <Badge text={`Límite: ${fmtDate(item.fecha_limite)}`} bg="var(--gold-light)" color="#92660a" />}
      </div>

      {isTeacher && (
        <div style={{ marginTop: 16, paddingTop: 14, borderTop: '1px solid var(--border)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <span style={{ fontSize: 12, color: 'var(--muted-foreground)' }}>
            {(item as ClassroomAssignmentTeacherView).resumenEntregas.Entregado +
              (item as ClassroomAssignmentTeacherView).resumenEntregas['Con retraso'] +
              (item as ClassroomAssignmentTeacherView).resumenEntregas.Revisado}{' '}
            de {(item as ClassroomAssignmentTeacherView).resumenEntregas.total} alumnos entregaron
          </span>
          <Button variant="secondary" small onClick={onReview}>
            Ver entregas
          </Button>
        </div>
      )}

      {isStudent && (
        <StudentSubmissionRow
          item={item as ClassroomAssignmentStudentView}
          submitting={!!submitting}
          onOpenSubmit={onOpenSubmit!}
          onCloseSubmit={onCloseSubmit!}
          onSubmitted={onSubmitted!}
        />
      )}
    </Card>
  )
}

function StudentSubmissionRow({
  item,
  submitting,
  onOpenSubmit,
  onCloseSubmit,
  onSubmitted,
}: {
  item: ClassroomAssignmentStudentView
  submitting: boolean
  onOpenSubmit: () => void
  onCloseSubmit: () => void
  onSubmitted: () => void
}) {
  const [files, setFiles] = useState<File[]>([])
  const [comentario, setComentario] = useState('')
  const [sending, setSending] = useState(false)
  const [err, setErr] = useState('')

  const entrega = item.miEntrega
  const yaEntregado = !!entrega && entrega.status !== 'Pendiente'
  const hasAttachments = (entrega?.adjuntos?.length ?? 0) > 0
  const hasLegacyFile = !!entrega?.archivo_nombre && !hasAttachments

  const submit = async () => {
    if (files.length === 0 && !comentario.trim()) {
      setErr('Adjunta al menos un archivo o escribe un comentario para entregar.')
      return
    }
    const filesMsg = validateFiles(files)
    if (filesMsg) {
      setErr(filesMsg)
      return
    }
    setSending(true)
    setErr('')
    try {
      const form = new FormData()
      files.forEach((f) => form.append('archivos', f))
      if (comentario.trim()) form.append('comentario', comentario.trim())
      await classroomService.submit(item.id, form)
      onSubmitted()
    } catch (e) {
      setErr(e instanceof ApiError ? e.message : 'No se pudo enviar tu trabajo.')
    } finally {
      setSending(false)
    }
  }

  return (
    <div style={{ marginTop: 16, paddingTop: 14, borderTop: '1px solid var(--border)' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 10 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
          <Badge text={entrega?.status ?? 'Pendiente'} bg={STATUS_STYLE[entrega?.status ?? 'Pendiente'].bg} color={STATUS_STYLE[entrega?.status ?? 'Pendiente'].color} />
          {entrega?.entregado_at && <span style={{ fontSize: 11.5, color: 'var(--muted-foreground)' }}>Entregado el {fmtDateTime(entrega.entregado_at)}</span>}
          {entrega?.calificacion !== null && entrega?.calificacion !== undefined && (
            <span style={{ fontSize: 13, fontWeight: 700, color: 'var(--primary)' }}>Calificación: {entrega.calificacion}</span>
          )}
        </div>
        {entrega?.status !== 'Revisado' && (
          <Button variant={yaEntregado ? 'secondary' : 'primary'} small onClick={submitting ? onCloseSubmit : onOpenSubmit}>
            {yaEntregado ? 'Volver a entregar' : 'Entregar trabajo'}
          </Button>
        )}
      </div>

      {hasAttachments && <AttachmentList items={entrega!.adjuntos} submissionId={entrega!.id} />}
      {hasLegacyFile && (
        <div style={{ marginTop: 10 }}>
          <Button variant="ghost" small onClick={() => triggerLegacyDownload(entrega!.id, entrega!.archivo_nombre!)}>
            Ver mi archivo
          </Button>
        </div>
      )}

      {submitting && (
        <div style={{ marginTop: 12, padding: 14, background: 'var(--background)', borderRadius: 10, display: 'grid', gap: 10 }}>
          <FilePicker id={`files-${item.id}`} files={files} onChange={setFiles} />
          <div style={{ display: 'grid', gap: 4 }}>
            <textarea
              value={comentario}
              onChange={(e) => setComentario(e.target.value.slice(0, TEXT_MAX))}
              maxLength={TEXT_MAX}
              placeholder="Comentario para tu profesor (opcional si adjuntas archivos)…"
              rows={2}
              style={{ padding: '8px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13, fontFamily: 'inherit', resize: 'vertical' }}
            />
            <CharCounter length={comentario.length} max={TEXT_MAX} />
          </div>
          {err && <span style={{ fontSize: 12, color: '#b42318' }}>{err}</span>}
          <div style={{ display: 'flex', gap: 8 }}>
            <Button variant="primary" small onClick={submit}>
              {sending ? 'Enviando…' : 'Enviar entrega'}
            </Button>
            <Button variant="secondary" small onClick={onCloseSubmit}>
              Cancelar
            </Button>
          </div>
        </div>
      )}
    </div>
  )
}

function NuevoAnuncioModal({
  group,
  subjects,
  onClose,
  onCreated,
}: {
  group: string
  subjects: SubjectOption[]
  onClose: () => void
  onCreated: () => void
}) {
  const [titulo, setTitulo] = useState('')
  const [mensaje, setMensaje] = useState('')
  const [subjectId, setSubjectId] = useState('')
  const [sending, setSending] = useState(false)
  const [err, setErr] = useState('')

  const submit = async () => {
    if (!titulo.trim() || !mensaje.trim()) {
      setErr('Escribe un título y un mensaje.')
      return
    }
    setSending(true)
    setErr('')
    try {
      await classroomService.createAnnouncement({ groupId: group, subjectId: subjectId || undefined, titulo: titulo.trim(), mensaje: mensaje.trim() })
      onCreated()
    } catch (e) {
      setErr(e instanceof ApiError ? e.message : 'No se pudo publicar el anuncio.')
    } finally {
      setSending(false)
    }
  }

  return (
    <Modal title={`Nuevo anuncio · ${group}`} onClose={onClose}>
      <div style={{ display: 'grid', gap: 12 }}>
        <div style={{ display: 'grid', gap: 4 }}>
          <input
            value={titulo}
            onChange={(e) => setTitulo(e.target.value.slice(0, TITLE_MAX))}
            maxLength={TITLE_MAX}
            placeholder="Título del anuncio"
            style={{ padding: '9px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13.5 }}
          />
          <CharCounter length={titulo.length} max={TITLE_MAX} />
        </div>
        {subjects.length > 0 && (
          <select
            value={subjectId}
            onChange={(e) => setSubjectId(e.target.value)}
            style={{ padding: '9px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13.5, background: '#fff' }}
          >
            <option value="">Materia (opcional)</option>
            {subjects.map((s) => (
              <option key={s.id} value={s.id}>
                {s.nombre}
              </option>
            ))}
          </select>
        )}
        <div style={{ display: 'grid', gap: 4 }}>
          <textarea
            value={mensaje}
            onChange={(e) => setMensaje(e.target.value.slice(0, TEXT_MAX))}
            maxLength={TEXT_MAX}
            placeholder="Escribe el anuncio para el grupo…"
            rows={5}
            style={{ padding: '9px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13.5, fontFamily: 'inherit', resize: 'vertical' }}
          />
          <CharCounter length={mensaje.length} max={TEXT_MAX} />
        </div>
        {err && <span style={{ fontSize: 12, color: '#b42318' }}>{err}</span>}
        <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
          <Button variant="secondary" onClick={onClose}>
            Cancelar
          </Button>
          <Button variant="primary" onClick={submit}>
            {sending ? 'Publicando…' : 'Publicar anuncio'}
          </Button>
        </div>
      </div>
    </Modal>
  )
}

function NuevoTrabajoModal({
  group,
  subjects,
  onClose,
  onCreated,
}: {
  group: string
  subjects: SubjectOption[]
  onClose: () => void
  onCreated: () => void
}) {
  const [titulo, setTitulo] = useState('')
  const [descripcion, setDescripcion] = useState('')
  const [tipo, setTipo] = useState<'Tarea' | 'Proyecto' | 'Exposición' | 'Investigación'>('Tarea')
  const [subjectId, setSubjectId] = useState('')
  const [fechaLimite, setFechaLimite] = useState('')
  const [files, setFiles] = useState<File[]>([])
  const [sending, setSending] = useState(false)
  const [err, setErr] = useState('')

  const submit = async () => {
    if (!titulo.trim()) {
      setErr('Escribe un título para el trabajo.')
      return
    }
    const filesMsg = validateFiles(files)
    if (filesMsg) {
      setErr(filesMsg)
      return
    }
    setSending(true)
    setErr('')
    try {
      const form = new FormData()
      form.append('groupId', group)
      if (subjectId) form.append('subjectId', subjectId)
      form.append('titulo', titulo.trim())
      if (descripcion.trim()) form.append('descripcion', descripcion.trim())
      form.append('tipo', tipo)
      if (fechaLimite) form.append('fechaLimite', fechaLimite)
      files.forEach((f) => form.append('archivos', f))
      await classroomService.createAssignment(form)
      onCreated()
    } catch (e) {
      setErr(e instanceof ApiError ? e.message : 'No se pudo publicar el trabajo.')
    } finally {
      setSending(false)
    }
  }

  return (
    <Modal title={`Nuevo trabajo · ${group}`} onClose={onClose}>
      <div style={{ display: 'grid', gap: 12 }}>
        <div style={{ display: 'grid', gap: 4 }}>
          <input
            value={titulo}
            onChange={(e) => setTitulo(e.target.value.slice(0, TITLE_MAX))}
            maxLength={TITLE_MAX}
            placeholder="Título del trabajo"
            style={{ padding: '9px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13.5 }}
          />
          <CharCounter length={titulo.length} max={TITLE_MAX} />
        </div>
        <div className="rg-2" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          <select
            value={tipo}
            onChange={(e) => setTipo(e.target.value as typeof tipo)}
            style={{ padding: '9px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13.5, background: '#fff' }}
          >
            <option>Tarea</option>
            <option>Proyecto</option>
            <option>Exposición</option>
            <option>Investigación</option>
          </select>
          <input
            type="date"
            value={fechaLimite}
            onChange={(e) => setFechaLimite(e.target.value)}
            style={{ padding: '9px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13.5 }}
          />
        </div>
        {subjects.length > 0 && (
          <select
            value={subjectId}
            onChange={(e) => setSubjectId(e.target.value)}
            style={{ padding: '9px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13.5, background: '#fff' }}
          >
            <option value="">Materia (opcional)</option>
            {subjects.map((s) => (
              <option key={s.id} value={s.id}>
                {s.nombre}
              </option>
            ))}
          </select>
        )}
        <div style={{ display: 'grid', gap: 4 }}>
          <textarea
            value={descripcion}
            onChange={(e) => setDescripcion(e.target.value.slice(0, TEXT_MAX))}
            maxLength={TEXT_MAX}
            placeholder="Instrucciones para el trabajo (opcional)…"
            rows={4}
            style={{ padding: '9px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13.5, fontFamily: 'inherit', resize: 'vertical' }}
          />
          <CharCounter length={descripcion.length} max={TEXT_MAX} />
        </div>
        <FilePicker id="trabajo-nuevo-archivos" files={files} onChange={setFiles} />
        {err && <span style={{ fontSize: 12, color: '#b42318' }}>{err}</span>}
        <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
          <Button variant="secondary" onClick={onClose}>
            Cancelar
          </Button>
          <Button variant="primary" onClick={submit}>
            {sending ? 'Publicando…' : 'Publicar trabajo'}
          </Button>
        </div>
      </div>
    </Modal>
  )
}

function RevisarEntregasModal({
  item,
  readOnly,
  onClose,
  onChanged,
}: {
  item: ClassroomAssignmentTeacherView
  readOnly?: boolean
  onClose: () => void
  onChanged: () => void
}) {
  const [entregas, setEntregas] = useState<Submission[]>([])
  const [loading, setLoading] = useState(true)
  const [err, setErr] = useState('')
  const [grades, setGrades] = useState<Record<string, string>>({})
  const [saving, setSaving] = useState<string | null>(null)

  useEffect(() => {
    classroomService
      .submissions(item.id)
      .then((data) => setEntregas(data.entregas))
      .catch((e) => setErr(e instanceof ApiError ? e.message : 'No se pudieron cargar las entregas.'))
      .finally(() => setLoading(false))
  }, [item.id])

  const calificar = async (sub: Submission) => {
    const val = grades[sub.id]
    if (val) {
      const num = Number(val)
      if (Number.isNaN(num) || num < 1 || num > 10) {
        alert('La calificación debe ser un número entre 1 y 10.')
        return
      }
    }
    setErr('')
    setSaving(sub.id)
    try {
      await classroomService.calificar(sub.id, val ? Number(val) : undefined)
      const data = await classroomService.submissions(item.id)
      setEntregas(data.entregas)
      onChanged()
    } catch (e) {
      alert(e instanceof ApiError ? e.message : 'No se pudo guardar la calificación.')
    } finally {
      setSaving(null)
    }
  }

  return (
    <Modal title={`Entregas · ${item.titulo}`} onClose={onClose} width={720}>
      {loading && <p style={{ fontSize: 13, color: 'var(--muted-foreground)' }}>Cargando…</p>}
      {err && <p style={{ fontSize: 13, color: '#b42318' }}>{err}</p>}
      <div style={{ display: 'grid', gap: 10 }}>
        {entregas.map((e) => {
          const hasAttachments = (e.adjuntos?.length ?? 0) > 0
          const hasLegacyFile = !!e.archivo_nombre && !hasAttachments
          return (
            <div key={e.id} style={{ padding: '10px 12px', border: '1px solid var(--border)', borderRadius: 10 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 8 }}>
                <div>
                  <div style={{ fontSize: 13, fontWeight: 600 }}>{e.alumno}</div>
                  <div style={{ fontSize: 11.5, color: 'var(--muted-foreground)' }}>
                    {e.expediente} · {e.entregado_at ? `Entregado ${fmtDateTime(e.entregado_at)}` : 'Sin entregar'}
                  </div>
                  {e.comentario && <div style={{ fontSize: 12, color: 'var(--foreground)', marginTop: 4 }}>{e.comentario}</div>}
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <Badge text={e.status} bg={STATUS_STYLE[e.status].bg} color={STATUS_STYLE[e.status].color} />
                  {hasLegacyFile && (
                    <Button variant="ghost" small onClick={() => triggerLegacyDownload(e.id, e.archivo_nombre!)}>
                      Ver archivo
                    </Button>
                  )}
                  {e.status !== 'Pendiente' && !readOnly && (
                    <>
                      <input
                        type="number"
                        min={1}
                        max={10}
                        step={0.1}
                        placeholder={e.calificacion?.toString() ?? 'Cal.'}
                        value={grades[e.id] ?? ''}
                        onChange={(ev) => setGrades((g) => ({ ...g, [e.id]: ev.target.value }))}
                        style={{ width: 56, padding: '6px 8px', borderRadius: 6, border: '1px solid var(--border)', fontSize: 12.5 }}
                      />
                      <Button variant="secondary" small onClick={() => calificar(e)}>
                        {saving === e.id ? '…' : 'Revisar'}
                      </Button>
                    </>
                  )}
                  {e.status !== 'Pendiente' && readOnly && e.calificacion !== null && e.calificacion !== undefined && (
                    <span style={{ fontSize: 13, fontWeight: 700, color: 'var(--primary)' }}>Cal.: {e.calificacion}</span>
                  )}
                </div>
              </div>
              {hasAttachments && <AttachmentList items={e.adjuntos} submissionId={e.id} />}
            </div>
          )
        })}
      </div>
    </Modal>
  )
}