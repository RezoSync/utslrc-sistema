import { useState, useEffect } from 'react'
import { GROUPS } from '../data/students'
import { SCHEDULE_SLOTS, setScheduleSlots, CAREERS } from '../data/academic'
import { TEACHERS } from '../data/teachers'
import { GROUPS_DATA } from '../data/groups'
import { Card, Table, Select, Button } from '../components/ui'
import { authService } from '../services/auth'
import { api } from '../services/api'
import { loadAppData } from '../services/loadData'

export default function Horarios() {
  const [viewMode, setViewMode] = useState<'grupo' | 'docente'>('grupo')
  const [grupo, setGrupo] = useState(GROUPS[0])
  const [docente, setDocente] = useState('')
  const [generating, setGenerating] = useState(false)
  const [saving, setSaving] = useState(false)
  const [deleting, setDeleting] = useState(false)
  const [consulting, setConsulting] = useState(false)
  const [screenCleared, setScreenCleared] = useState(false)
  const [activeCuatri, setActiveCuatri] = useState('8vo')
  const [isConsultModalOpen, setIsConsultModalOpen] = useState(false)
  const [selectedCareer, setSelectedCareer] = useState('Ingeniería en Desarrollo y Gestión de Software (IDGS)')
  const [selectedPeriod, setSelectedPeriod] = useState('8vo Cuatrimestre (Enero - Abril 2025)')
  const [progress, setProgress] = useState(0)
  const [status, setStatus] = useState<{ message: string; type: 'success' | 'error' } | null>(null)

  // Inicializar docente cuando la lista se cargue
  useEffect(() => {
    if (TEACHERS.length > 0 && !docente) {
      setDocente(TEACHERS[0].nombre)
    }
  }, [docente])

  const slots = (screenCleared || activeCuatri !== '8vo')
    ? []
    : (viewMode === 'grupo'
      ? SCHEDULE_SLOTS.filter((s) => s.grupo === grupo)
      : SCHEDULE_SLOTS.filter((s) => s.docente === docente))

  const user = authService.getCurrentUser()
  const isAdmin = user?.role === 'Administrador' || user?.role === 'Control Escolar'

  const DAYS = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes']

  // Extraer las horas únicas y ordenarlas cronológicamente por su hora de inicio
  const uniqueHours = Array.from(new Set(slots.map((s) => s.hora))).sort((a, b) => {
    const getStart = (h: string) => {
      const match = h.match(/(\d{2}):(\d{2})/)
      if (!match) return 0
      return parseInt(match[1], 10) + parseInt(match[2], 10) / 60
    }
    return getStart(a) - getStart(b)
  })

  const handleGenerate = async () => {
    const confirmGen = window.confirm(
      '¿Estás seguro de que deseas generar nuevos horarios para el cuatrimestre? Esto reemplazará el horario actual.'
    )
    if (!confirmGen) return

    setGenerating(true)
    setProgress(0)
    setStatus(null)

    // Simulación de carga fluida
    const interval = setInterval(() => {
      setProgress((prev) => {
        if (prev >= 90) return 90
        const increment = Math.max(1, Math.floor((95 - prev) * 0.12))
        return prev + increment
      })
    }, 150)

    try {
      const res = await api.post<{ message: string; slots: any[] }>('/schedules/generate')
      clearInterval(interval)
      setProgress(100)

      // Breve retraso para que el usuario pueda ver el 100%
      await new Promise((resolve) => setTimeout(resolve, 300))

      // Guardar el borrador en memoria directamente sin llamar a loadAppData()
      setScheduleSlots(res.slots || [])
      setScreenCleared(false)
      setActiveCuatri('8vo')

      setStatus({
        message: 'Borrador de horarios generado correctamente. Presiona "Guardar" para confirmarlos en la base de datos.',
        type: 'success',
      })
    } catch (err: any) {
      clearInterval(interval)
      setProgress(0)
      console.error(err)
      setStatus({
        message: err.message || 'Error al intentar generar los horarios.',
        type: 'error',
      })
    } finally {
      setTimeout(() => {
        setGenerating(false)
        setProgress(0)
      }, 500)
    }
  }

  const handleSave = async () => {
    setSaving(true)
    setStatus(null)
    try {
      const res = await api.post<{ message: string }>('/schedules/save', { slots: SCHEDULE_SLOTS })
      setStatus({
        message: res.message || 'Horarios guardados correctamente en la base de datos.',
        type: 'success',
      })
    } catch (err: any) {
      console.error(err)
      setStatus({
        message: err?.response?.data?.error || err.message || 'Error al guardar los horarios.',
        type: 'error',
      })
    } finally {
      setSaving(false)
    }
  }

  const getActiveGroupCareerAndCuatri = () => {
    // Buscar los detalles del grupo actual
    const groupInfo = GROUPS_DATA.find((g) => g.id === grupo)
    if (!groupInfo) return { careerId: null, cuatrimestre: null, careerName: null }
    
    // Buscar la carrera correspondiente en CAREERS
    const careerInfo = CAREERS.find((c) => c.nombre === groupInfo.carrera)
    const careerId = careerInfo ? careerInfo.id : null
    
    return {
      careerId,
      cuatrimestre: groupInfo.cuatrimestre,
      careerName: groupInfo.carrera,
    }
  }

  const handleDeleteAll = async () => {
    // Obtener los datos del grupo actual
    const { careerId, cuatrimestre, careerName } = getActiveGroupCareerAndCuatri()
    
    if (!careerId || !cuatrimestre) {
      alert('No se pudo identificar la carrera y cuatrimestre a eliminar.')
      return
    }

    const confirmDelete = window.confirm(
      `¿Estás seguro de que deseas eliminar TODOS los horarios de la carrera "${careerName}" para el cuatrimestre "${cuatrimestre}"? Esta acción no se puede deshacer.`
    )
    if (!confirmDelete) return

    setDeleting(true)
    setStatus(null)
    try {
      const res = await api.delete<{ message: string }>(
        `/schedules?career=${encodeURIComponent(careerId)}&cuatrimestre=${encodeURIComponent(cuatrimestre)}`
      )
      await loadAppData()
      setScreenCleared(false)
      setStatus({
        message: res.message || 'Horarios eliminados correctamente.',
        type: 'success',
      })
    } catch (err: any) {
      console.error(err)
      setStatus({
        message: err?.response?.data?.error || err.message || 'Error al intentar eliminar los horarios.',
        type: 'error',
      })
    } finally {
      setDeleting(false)
    }
  }

  const handleConsult = () => {
    setIsConsultModalOpen(true)
  }

  const handleExecuteConsult = async () => {
    setIsConsultModalOpen(false)
    setConsulting(true)
    setStatus(null)
    try {
      await loadAppData()
      setScreenCleared(false)
      
      const cuatri = selectedPeriod.startsWith('8vo') ? '8vo' : (selectedPeriod.startsWith('5to') ? '5to' : '2do')
      setActiveCuatri(cuatri)
      
      // Filtro inteligente para demostrar consulta multi-carrera
      if (selectedCareer.includes('MECA')) {
        setViewMode('grupo')
        setGrupo('MECA 8-1')
      } else if (selectedCareer.includes('GEMP')) {
        setViewMode('grupo')
        setGrupo('GEMP 8-1')
      } else if (selectedCareer.includes('IDGS')) {
        setViewMode('grupo')
        setGrupo('IDGS 8-1')
      } else {
        setStatus({
          message: `La carrera seleccionada no cuenta con horarios registrados para el periodo ${selectedPeriod.split(' ')[0]}.`,
          type: 'error',
        })
      }
    } catch (err: any) {
      console.error(err)
      setStatus({
        message: err?.response?.data?.error || err.message || 'Error al consultar los horarios desde el servidor.',
        type: 'error',
      })
    } finally {
      setConsulting(false)
    }
  }

  const handleClearScreen = () => {
    setScreenCleared(true)
    setStatus({
      message: 'Los horarios en pantalla han sido limpiados temporalmente. (Nota: Esto no modifica la base de datos).',
      type: 'success',
    })
  }

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      {generating && (
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          width: '100%',
          height: '4px',
          background: '#f3f4f6',
          zIndex: 9999,
        }}>
          <div style={{
            width: `${progress}%`,
            height: '100%',
            background: 'var(--primary)',
            transition: 'width 0.2s ease-out',
            boxShadow: '0 0 10px var(--primary)',
          }} />
        </div>
      )}
      {status && (
        <div
          style={{
            padding: '12px 16px',
            borderRadius: 8,
            backgroundColor: status.type === 'success' ? 'rgba(25, 183, 124, 0.1)' : 'rgba(239, 68, 68, 0.1)',
            border: `1px solid ${status.type === 'success' ? 'var(--primary)' : '#ef4444'}`,
            color: status.type === 'success' ? 'var(--primary-dark)' : '#b91c1c',
            fontSize: 13.5,
            fontWeight: 500,
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
          }}
        >
          <span>{status.message}</span>
          <button
            onClick={() => setStatus(null)}
            style={{
              background: 'none',
              border: 'none',
              color: 'inherit',
              cursor: 'pointer',
              fontWeight: 'bold',
              fontSize: 14,
            }}
          >
            ✕
          </button>
        </div>
      )}

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 16 }}>
        <div>
          <h1 style={{ fontSize: 22, margin: 0 }}>Horarios</h1>
          <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>Horario semanal por grupo o profesor.</p>
          
          {/* Segmented Control / Tabs */}
          <div style={{ display: 'flex', gap: 4, background: '#e5eaee', padding: 4, borderRadius: 8, marginTop: 12, width: 'max-content' }}>
            <button
              onClick={() => { setViewMode('grupo'); setScreenCleared(false); setActiveCuatri('8vo'); }}
              style={{
                border: 'none',
                background: viewMode === 'grupo' ? '#fff' : 'transparent',
                color: viewMode === 'grupo' ? 'var(--foreground)' : 'var(--muted-foreground)',
                padding: '6px 14px',
                borderRadius: 6,
                fontSize: 12.5,
                fontWeight: 600,
                cursor: 'pointer',
                boxShadow: viewMode === 'grupo' ? '0 2px 5px rgba(0,0,0,0.06)' : 'none',
                transform: 'none',
                transition: 'all 0.15s ease',
              }}
            >
              Por Grupo
            </button>
            <button
              onClick={() => { setViewMode('docente'); setScreenCleared(false); setActiveCuatri('8vo'); }}
              style={{
                border: 'none',
                background: viewMode === 'docente' ? '#fff' : 'transparent',
                color: viewMode === 'docente' ? 'var(--foreground)' : 'var(--muted-foreground)',
                padding: '6px 14px',
                borderRadius: 6,
                fontSize: 12.5,
                fontWeight: 600,
                cursor: 'pointer',
                boxShadow: viewMode === 'docente' ? '0 2px 5px rgba(0,0,0,0.06)' : 'none',
                transform: 'none',
                transition: 'all 0.15s ease',
              }}
            >
              Por Profesor
            </button>
          </div>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
          {isAdmin && (
            <>
              {/* Botón Generar */}
              <Button
                variant="primary"
                onClick={handleGenerate}
                disabled={generating || saving || deleting || consulting}
                style={{
                  background: generating ? 'var(--muted)' : 'linear-gradient(135deg, var(--primary), var(--primary-dark))',
                  borderColor: generating ? 'var(--border)' : 'var(--primary)',
                  boxShadow: generating ? 'none' : '0 4px 10px rgba(0, 0, 0, 0.08)',
                }}
              >
                {generating ? (
                  <span style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <svg
                      style={{ animation: 'spin 1s linear infinite', width: 16, height: 16 }}
                      viewBox="0 0 24 24"
                      fill="none"
                    >
                      <circle cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" style={{ opacity: 0.25 }} />
                      <path fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                    </svg>
                    Generando...
                  </span>
                ) : (
                  'Generar'
                )}
              </Button>

              {/* Botón Guardar */}
              <Button
                variant="secondary"
                onClick={handleSave}
                disabled={generating || saving || deleting || consulting}
                style={{
                  background: saving ? 'var(--muted)' : 'rgba(25, 183, 124, 0.1)',
                  borderColor: saving ? 'var(--border)' : 'var(--primary)',
                  color: 'var(--primary-dark)',
                  boxShadow: 'none',
                }}
              >
                {saving ? 'Guardando...' : 'Guardar'}
              </Button>

              {/* Botón Consultar */}
              <Button
                variant="secondary"
                onClick={handleConsult}
                disabled={generating || saving || deleting || consulting}
                style={{
                  background: consulting ? 'var(--muted)' : 'rgba(30, 41, 59, 0.05)',
                  borderColor: 'rgba(30, 41, 59, 0.1)',
                  color: 'var(--navy)',
                  boxShadow: 'none',
                }}
              >
                {consulting ? 'Consultando...' : 'Consultar'}
              </Button>

              {/* Botón Limpiar */}
              <Button
                variant="secondary"
                onClick={handleClearScreen}
                disabled={generating || saving || deleting || consulting}
                style={{
                  background: 'rgba(30, 41, 59, 0.05)',
                  borderColor: 'rgba(30, 41, 59, 0.1)',
                  color: 'var(--navy)',
                  boxShadow: 'none',
                }}
              >
                Limpiar
              </Button>

              {/* Botón Eliminar */}
              <Button
                variant="secondary"
                onClick={handleDeleteAll}
                disabled={generating || saving || deleting || consulting}
                style={{
                  background: deleting ? 'var(--muted)' : 'rgba(239, 68, 68, 0.1)',
                  borderColor: 'rgba(239, 68, 68, 0.2)',
                  color: '#ef4444',
                  boxShadow: 'none',
                }}
              >
                {deleting ? 'Eliminando...' : 'Eliminar'}
              </Button>
            </>
          )}
          {viewMode === 'docente' && (
            <Select
              value={docente}
              onChange={(val) => { setDocente(val); setScreenCleared(false); setActiveCuatri('8vo'); }}
              options={Array.from(new Set(TEACHERS.map((t) => t.nombre))).sort()}
            />
          )}
        </div>
      </div>

      {generating && (
        <Card style={{ display: 'flex', flexDirection: 'column', gap: 12, borderLeft: '4px solid var(--primary)', animation: 'fadeIn 0.3s ease' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, fontWeight: 600 }}>
            <span style={{ color: 'var(--foreground)' }}>Generando horarios optimizados...</span>
            <span style={{ color: 'var(--primary-dark)' }}>{progress}%</span>
          </div>
          <div style={{ width: '100%', height: 8, background: '#e5eaee', borderRadius: 4, overflow: 'hidden' }}>
            <div
              style={{
                width: `${progress}%`,
                height: '100%',
                background: 'linear-gradient(90deg, var(--primary), var(--primary-dark))',
                borderRadius: 4,
                transition: 'width 0.15s ease-out',
              }}
            />
          </div>
          <small style={{ color: 'var(--muted-foreground)', fontSize: 11.5, display: 'block' }}>
            El solver de programación lineal CP-SAT está analizando combinaciones de aulas, docentes y restricciones de horarios...
          </small>
        </Card>
      )}
      {uniqueHours.length === 0 ? (
        <Card style={{ display: 'grid', placeItems: 'center', padding: 48, textAlign: 'center' }}>
          <div>
            <div style={{ fontSize: 40, marginBottom: 12 }}>📅</div>
            <h3 style={{ margin: '0 0 6px', fontSize: 16, fontWeight: 700 }}>Sin horario disponible</h3>
            <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: 0 }}>
              No se han encontrado registros de horarios para este grupo.
            </p>
          </div>
        </Card>
      ) : (
        <Card style={{ padding: 16 }}>
          <Table headers={['Hora', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes']}>
            {uniqueHours.map((hour, idx) => (
              <tr key={idx} style={{ borderBottom: '1px solid var(--border)' }}>
                <td style={{ padding: '14px 12px', fontWeight: 700, color: 'var(--navy)', width: 120, verticalAlign: 'middle' }}>
                  {hour}
                </td>
                {DAYS.map((day) => {
                  const slot = slots.find((s) => s.dia === day && s.hora === hour)
                  return (
                    <td key={day} style={{ padding: '8px', verticalAlign: 'top', width: '18%' }}>
                      {slot ? (
                        <div
                          style={{
                            background: 'var(--secondary)',
                            borderLeft: '4px solid var(--primary)',
                            borderRadius: 8,
                            padding: '10px 12px',
                            display: 'flex',
                            flexDirection: 'column',
                            gap: 4,
                            boxShadow: '0 2px 4px rgba(0, 0, 0, 0.02)',
                            transition: 'transform 0.15s ease',
                          }}
                        >
                          <div style={{ fontWeight: 600, fontSize: 12, color: 'var(--foreground)', lineHeight: 1.25 }}>
                            {slot.materia}
                          </div>
                          <div style={{ fontSize: 10.5, color: 'var(--muted-foreground)', fontWeight: 500 }}>
                            {viewMode === 'grupo' ? slot.docente : `Grupo: ${slot.grupo}`}
                          </div>
                          <div
                            style={{
                              alignSelf: 'flex-start',
                              fontSize: 9,
                              fontWeight: 700,
                              background: 'var(--navy)',
                              color: '#fff',
                              padding: '2px 6px',
                              borderRadius: 4,
                              marginTop: 4,
                            }}
                          >
                            {slot.aula}
                          </div>
                        </div>
                      ) : (
                        <div
                          style={{
                            minHeight: 70,
                            border: '1px dashed var(--border)',
                            borderRadius: 8,
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            color: '#b0bcd4',
                            fontSize: 14,
                          }}
                        >
                          -
                        </div>
                      )}
                    </td>
                  )
                })}
              </tr>
            ))}
          </Table>
        </Card>
      )}
      {isConsultModalOpen && (
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          width: '100vw',
          height: '100vh',
          backgroundColor: 'rgba(15, 23, 42, 0.6)',
          backdropFilter: 'blur(4px)',
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          zIndex: 10000,
        }}>
          <div style={{
            background: '#fff',
            border: '1px solid var(--border)',
            borderRadius: 12,
            padding: 24,
            width: '100%',
            maxWidth: 440,
            boxShadow: '0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04)',
            display: 'flex',
            flexDirection: 'column',
            gap: 16,
          }}>
            <div>
              <h3 style={{ margin: 0, fontSize: 18, fontWeight: 700, color: 'var(--foreground)' }}>
                Consultar Horario Académico
              </h3>
              <p style={{ margin: '6px 0 0', fontSize: 12.5, color: 'var(--muted-foreground)' }}>
                Selecciona la carrera y periodo para consultar su esquema de horarios.
              </p>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
              <div>
                <label style={{ display: 'block', fontSize: 12, fontWeight: 600, marginBottom: 6, color: 'var(--muted-foreground)' }}>
                  Carrera
                </label>
                <Select
                  value={selectedCareer}
                  onChange={setSelectedCareer}
                  options={[
                    'Ingeniería en Desarrollo y Gestión de Software (IDGS)',
                    'Ingeniería en Mecatrónica (MECA)',
                    'Lic. en Gestión y Administración de PyMEs (GEMP)',
                    'TSU en Tecnologías de la Información (TIC)',
                  ]}
                  style={{ width: '100%' }}
                />
              </div>

              <div>
                <label style={{ display: 'block', fontSize: 12, fontWeight: 600, marginBottom: 6, color: 'var(--muted-foreground)' }}>
                  Periodo / Cuatrimestre
                </label>
                <Select
                  value={selectedPeriod}
                  onChange={setSelectedPeriod}
                  options={[
                    '8vo Cuatrimestre (Enero - Abril 2025)',
                    '5to Cuatrimestre (Enero - Abril 2025)',
                    '2do Cuatrimestre (Enero - Abril 2025)',
                  ]}
                  style={{ width: '100%' }}
                />
              </div>
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10, marginTop: 8 }}>
              <Button
                variant="secondary"
                onClick={() => setIsConsultModalOpen(false)}
                style={{
                  background: 'rgba(30, 41, 59, 0.05)',
                  borderColor: 'rgba(30, 41, 59, 0.1)',
                  color: 'var(--navy)',
                }}
              >
                Cancelar
              </Button>
              <Button
                variant="primary"
                onClick={handleExecuteConsult}
                style={{
                  background: 'linear-gradient(135deg, var(--primary), var(--primary-dark))',
                  borderColor: 'var(--primary)',
                }}
              >
                Consultar Horario
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
