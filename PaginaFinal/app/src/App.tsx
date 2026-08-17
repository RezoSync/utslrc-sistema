import { useEffect, useState } from 'react'
import Sidebar from './components/Sidebar'
import TopBar from './components/TopBar'
import PublicPortal from './pages/PublicPortal'
import Login from './pages/Login'
import Dashboard from './pages/Dashboard'
import Grupos from './pages/Grupos'
import ControlAlumnado from './pages/ControlAlumnado'
import Docentes from './pages/Docentes'
import Carreras from './pages/Carreras'
import Materias from './pages/Materias'
import Calificaciones from './pages/Calificaciones'
import Asistencia from './pages/Asistencia'
import Horarios from './pages/Horarios'
import Inscripciones from './pages/Inscripciones'
import Kardex from './pages/Kardex'
import Biblioteca from './pages/Biblioteca'
import Inventarios from './pages/Inventarios'
import PlataformaTrabajos from './pages/PlataformaTrabajos'
import Servicios from './pages/Servicios'
import Reportes from './pages/Reportes'
import Configuracion from './pages/Configuracion'
import MiEspacio from './pages/MiEspacio'
import Perfil from './pages/Perfil'
import NotFound from './pages/NotFound'
import { PAGE_TITLES, ROLE_PAGES } from './nav'
import type { PageId, Role, ViewMode } from './types'
import { authService } from './services/auth'
import type { AuthUser } from './services/auth'
import { loadAppData, loadPublicData } from './services/loadData'
import type { Crumb } from './components/Breadcrumbs'

export interface SubCrumb {
  label: string
  onHome: () => void
}

function LoadingScreen({ label }: { label: string }) {
  return (
    <div style={{ minHeight: '100vh', display: 'grid', placeItems: 'center', background: 'var(--background)' }}>
      <div style={{ textAlign: 'center', color: 'var(--muted-foreground)', fontSize: 13.5 }}>{label}</div>
    </div>
  )
}

function ErrorScreen({ message, onRetry }: { message: string; onRetry: () => void }) {
  return (
    <div style={{ minHeight: '100vh', display: 'grid', placeItems: 'center', background: 'var(--background)', padding: 20 }}>
      <div style={{ maxWidth: 420, textAlign: 'center' }}>
        <p style={{ color: '#a33', fontSize: 13.5, marginBottom: 14 }}>{message}</p>
        <button
          onClick={onRetry}
          style={{ background: 'var(--primary)', color: '#fff', border: 'none', borderRadius: 10, padding: '10px 18px', fontWeight: 700, cursor: 'pointer' }}
        >
          Reintentar
        </button>
      </div>
    </div>
  )
}

export default function App() {
  const [view, setView] = useState<ViewMode>('public')
  const [role, setRole] = useState<Role>('Administrador')
  const [nombre, setNombre] = useState('')
  const [studentId, setStudentId] = useState<string | null>(null)
  const [teacherId, setTeacherId] = useState<string | null>(null)
  const [currentPage, setCurrentPage] = useState<PageId>('dashboard')
  const [grupoFiltro, setGrupoFiltro] = useState<string | undefined>(undefined)
  // Nivel extra de breadcrumb que una página puede reportar hacia arriba
  // (p. ej. "Materia: Inglés" dentro de Plataforma de Trabajos).
  const [subCrumb, setSubCrumb] = useState<SubCrumb | null>(null)
  const [status, setStatus] = useState<'loading' | 'ready' | 'error'>('loading')
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const [errorMsg, setErrorMsg] = useState('')
  const [publicStats, setPublicStats] = useState({ totalStudents: 0, totalGroups: 0, promedioGlobal: 0, totalCareers: 0 })

  // Al montar: si ya hay sesión guardada, recarga datos de app directamente;
  // si no, carga los datos públicos para el portal.
  useEffect(() => {
    bootstrap()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  async function bootstrap() {
    setStatus('loading')
    try {
      if (authService.isAuthenticated()) {
        const user = authService.getCurrentUser()
        await loadAppData()
        if (user) {
          setRole(user.role)
          setNombre(user.nombre)
          setStudentId(user.studentId)
          setTeacherId(user.teacherId)
        }
        setView('app')
      } else {
        const stats = await loadPublicData()
        setPublicStats(stats)
        setView('public')
      }
      setStatus('ready')
    } catch (err) {
      setErrorMsg('No se pudo conectar con el servidor. Verifica que el backend esté encendido en http://localhost:57913.')
      setStatus('error')
    }
  }

  async function handleLogin(user: AuthUser) {
    setStatus('loading')
    try {
      await loadAppData()
      setRole(user.role)
      setNombre(user.nombre)
      setStudentId(user.studentId)
      setTeacherId(user.teacherId)
      setCurrentPage(ROLE_PAGES[user.role].includes('dashboard') ? 'dashboard' : ROLE_PAGES[user.role][0])
      setView('app')
      setStatus('ready')
    } catch (err) {
      setErrorMsg('Se inició sesión, pero no se pudieron cargar los datos del sistema.')
      setStatus('error')
    }
  }

  function handleExit() {
    authService.logout()
    setView('public')
    setNombre('')
    setStudentId(null)
    setTeacherId(null)
    bootstrap()
  }

  if (status === 'loading') return <LoadingScreen label="Cargando…" />
  if (status === 'error') return <ErrorScreen message={errorMsg} onRetry={bootstrap} />

  if (view === 'public') {
    return <PublicPortal onGoLogin={() => setView('login')} stats={publicStats} />
  }

  if (view === 'login') {
    return <Login onLogin={handleLogin} onBackToPublic={() => setView('public')} />
  }

  const navigate = (page: PageId) => {
    if (page !== 'alumnos') setGrupoFiltro(undefined)
    if (page !== currentPage) setSubCrumb(null)
    setCurrentPage(page)
  }

  const openGroup = (grupo: string) => {
    setGrupoFiltro(grupo)
    setCurrentPage('alumnos')
  }

  // Si currentPage no está en las páginas permitidas para este rol (enlace roto,
  // navegación programática a una sección sin permiso, etc.), se muestra 404
  // en vez del contenido real de la página.
  const pageAllowed = ROLE_PAGES[role].includes(currentPage)

  // Construye el rastro de breadcrumbs de la página actual.
  const crumbs: Crumb[] = []
  if (currentPage !== 'dashboard' && pageAllowed) {
    crumbs.push({ label: 'Inicio', onClick: () => navigate('dashboard') })
    if (currentPage === 'alumnos' && grupoFiltro) {
      // Caso especial: se llegó desde Grupos → un grupo en particular.
      crumbs.push({ label: 'Grupos', onClick: () => navigate('grupos') })
      crumbs.push({ label: grupoFiltro })
    } else {
      crumbs.push({
        label: PAGE_TITLES[currentPage].title,
        onClick: subCrumb ? subCrumb.onHome : undefined,
      })
      if (subCrumb) crumbs.push({ label: subCrumb.label })
    }
  }

  const renderPage = () => {
    switch (currentPage) {
      case 'dashboard':
        return <Dashboard onNavigate={navigate} role={role} studentId={studentId} teacherId={teacherId} />
      case 'mi-espacio':
        return <MiEspacio onNavigate={navigate} />
      case 'perfil':
        return <Perfil role={role} studentId={studentId} teacherId={teacherId} onExit={handleExit} />
      case 'grupos':
        return <Grupos onOpenGroup={openGroup} />
      case 'alumnos':
        return <ControlAlumnado initialGrupo={grupoFiltro} role={role} />
      case 'docentes':
        return <Docentes role={role} />
      case 'carreras':
        return <Carreras />
      case 'materias':
        return <Materias />
      case 'calificaciones':
        return <Calificaciones role={role} studentId={studentId} teacherId={teacherId} />
      case 'asistencia':
        return <Asistencia role={role} studentId={studentId} teacherId={teacherId} />
      case 'horarios':
        return <Horarios />
      case 'inscripciones':
        return <Inscripciones />
      case 'kardex':
        return <Kardex role={role} studentId={studentId} />
      case 'biblioteca':
        return <Biblioteca role={role} />
      case 'inventarios':
        return <Inventarios />
      case 'plataforma-trabajos':
        return <PlataformaTrabajos role={role} studentId={studentId} teacherId={teacherId} onSubCrumbChange={setSubCrumb} />
      case 'servicios':
        return <Servicios role={role} studentId={studentId} />
      case 'reportes':
        return <Reportes />
      case 'configuracion':
        return <Configuracion role={role} />
    }
  }

  return (
    <div style={{ display: 'flex', height: '100vh', background: 'var(--background)', overflow: 'hidden' }}>
      <Sidebar
        currentPage={currentPage}
        onNavigate={navigate}
        role={role}
        onExit={handleExit}
        mobileOpen={sidebarOpen}
        onCloseMobile={() => setSidebarOpen(false)}
      />
      <div className={`sidebar-overlay${sidebarOpen ? ' is-open' : ''}`} onClick={() => setSidebarOpen(false)} />
      <div style={{ display: 'flex', flexDirection: 'column', flex: 1, minWidth: 0 }}>
        <TopBar
          title={pageAllowed ? PAGE_TITLES[currentPage].title : 'Página no encontrada'}
          subtitle={pageAllowed ? PAGE_TITLES[currentPage].subtitle : ''}
          role={role}
          nombre={nombre}
          crumbs={crumbs}
          onNavigate={navigate}
          onExit={handleExit}
          onToggleSidebar={() => setSidebarOpen((v) => !v)}
        />
        <main style={{ flex: 1, overflowY: 'auto' }}>{pageAllowed ? renderPage() : <NotFound onHome={() => navigate('dashboard')} />}</main>
      </div>
    </div>
  )
}