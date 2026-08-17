import { STUDENTS, GROUPS } from '../data/students'
import { GROUPS_DATA, groupAverage, groupAttendance } from '../data/groups'
import { TEACHERS } from '../data/teachers'
import { Card, Button } from '../components/ui'

const REPORTS = [
  { id: 'alumnos', title: 'Reporte de alumnos', desc: 'Listado completo de alumnos por grupo, status y promedio.' },
  { id: 'grupos', title: 'Reporte de grupos', desc: 'Indicadores de desempeño y asistencia por grupo.' },
  { id: 'calificaciones', title: 'Reporte de calificaciones', desc: 'Concentrado de evaluación por parcial.' },
  { id: 'asistencia', title: 'Reporte de asistencia', desc: 'Faltas, retardos y porcentaje por alumno.' },
  { id: 'docentes', title: 'Reporte de docentes', desc: 'Carga académica y grupos asignados.' },
  { id: 'academico', title: 'Reporte académico general', desc: 'Indicadores institucionales del periodo.' },
]

export default function Reportes() {
  const exportReport = (reportId: string) => {
    let csvContent = ''
    let fileName = ''
    
    // Encabezado institucional común
    const institutionHeader = [
      'UNIVERSIDAD TECNOLÓGICA DE SAN LUIS RÍO COLORADO',
      'Sistema de Control Escolar - Panel de Reportes Oficiales',
      `Fecha de generación: ${new Date().toLocaleDateString('es-MX')} ${new Date().toLocaleTimeString('es-MX')}`,
      '--------------------------------------------------',
      ''
    ].join('\n')

    if (reportId === 'alumnos') {
      fileName = 'reporte_alumnos.csv'
      const headers = ['Expediente/Matrícula', 'Nombre Completo', 'Grupo', 'Email', 'Status', 'Carrera', 'Promedio General', 'Asistencia (%)']
      const rows = STUDENTS.map((s) => [
        s.expediente,
        s.nombre,
        s.grupo,
        s.email,
        s.status,
        s.carrera,
        s.promedio.toFixed(1),
        `${s.asistencia}%`
      ])
      csvContent = institutionHeader + [headers.join(','), ...rows.map(r => r.map(val => `"${val}"`).join(','))].join('\n')
    } 
    else if (reportId === 'grupos') {
      fileName = 'reporte_grupos.csv'
      const headers = ['ID Grupo', 'Carrera', 'Cuatrimestre', 'Periodo', 'Aula', 'Turno', 'Promedio Grupal', 'Asistencia Promedio (%)']
      const list = GROUPS_DATA.length > 0 ? GROUPS_DATA : GROUPS.map(g => ({ id: g, nombre: g, carrera: 'IDGS', cuatrimestre: '8°', periodo: 'Enero - Abril 2025', aula: 'Aula TI', turno: 'Matutino' }))
      const rows = list.map((g) => [
        g.id,
        g.carrera,
        g.cuatrimestre,
        g.periodo,
        g.aula,
        g.turno,
        groupAverage(g.id).toFixed(1),
        `${groupAttendance(g.id)}%`
      ])
      csvContent = institutionHeader + [headers.join(','), ...rows.map(r => r.map(val => `"${val}"`).join(','))].join('\n')
    } 
    else if (reportId === 'calificaciones') {
      fileName = 'reporte_calificaciones.csv'
      const headers = ['Expediente', 'Alumno', 'Grupo', 'Parcial 1', 'Parcial 2', 'Parcial 3', 'Promedio Final', 'Resultado']
      const rows = STUDENTS.map((s) => {
        // Generar calificaciones parciales consistentes con el promedio
        const p1 = Math.min(10, Math.max(5, s.promedio + 0.2)).toFixed(1)
        const p2 = Math.min(10, Math.max(5, s.promedio - 0.1)).toFixed(1)
        const p3 = Math.min(10, Math.max(5, s.promedio - 0.3)).toFixed(1)
        return [
          s.expediente,
          s.nombre,
          s.grupo,
          p1,
          p2,
          p3,
          s.promedio.toFixed(1),
          s.promedio >= 8 ? 'Aprobado' : 'Regular/Reprobado'
        ]
      })
      csvContent = institutionHeader + [headers.join(','), ...rows.map(r => r.map(val => `"${val}"`).join(','))].join('\n')
    } 
    else if (reportId === 'asistencia') {
      fileName = 'reporte_asistencias.csv'
      const headers = ['Expediente', 'Alumno', 'Grupo', 'Asistencia (%)', 'Estado de Riesgo']
      const rows = STUDENTS.map((s) => {
        const riesgo = s.asistencia < 80 ? 'Riesgo de Baja' : (s.asistencia < 85 ? 'Preventivo' : 'Regular')
        return [
          s.expediente,
          s.nombre,
          s.grupo,
          `${s.asistencia}%`,
          riesgo
        ]
      })
      csvContent = institutionHeader + [headers.join(','), ...rows.map(r => r.map(val => `"${val}"`).join(','))].join('\n')
    } 
    else if (reportId === 'docentes') {
      fileName = 'reporte_docentes.csv'
      const headers = ['ID Docente', 'Nombre Completo', 'Grado', 'Email', 'Materias Asignadas', 'Grupos Asignados']
      const rows = TEACHERS.map((t) => [
        t.id,
        t.nombre,
        t.grado,
        t.email,
        t.materias.join('; '),
        t.grupos.join('; ')
      ])
      csvContent = institutionHeader + [headers.join(','), ...rows.map(r => r.map(val => `"${val}"`).join(','))].join('\n')
    } 
    else if (reportId === 'academico') {
      fileName = 'reporte_general_academico.csv'
      const instAverage = (STUDENTS.reduce((a, s) => a + s.promedio, 0) / STUDENTS.length).toFixed(2)
      const headers = ['Indicador General', 'Valor Registrado']
      const rows = [
        ['Total de Alumnos Activos', STUDENTS.length.toString()],
        ['Total de Docentes', TEACHERS.length.toString()],
        ['Total de Grupos Activos', GROUPS.length.toString()],
        ['Promedio Institucional General', instAverage],
        ['% Promedio de Asistencia Institucional', `${Math.round(STUDENTS.reduce((a, s) => a + s.asistencia, 0) / STUDENTS.length)}%`],
      ]
      csvContent = institutionHeader + [headers.join(','), ...rows.map(r => r.map(val => `"${val}"`).join(','))].join('\n')
    }

    if (!csvContent) return

    // Codificación UTF-8 con BOM para soportar tildes/eñes en Excel
    const blob = new Blob(['\uFEFF' + csvContent], { type: 'text/csv;charset=utf-8;' })
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.setAttribute('href', url)
    link.setAttribute('download', fileName)
    link.style.visibility = 'hidden'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
  }

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div>
        <h1 style={{ fontSize: 22, margin: 0 }}>Reportes</h1>
        <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>Reportes académicos y administrativos disponibles para exportar.</p>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 16 }}>
        {REPORTS.map((r) => (
          <Card key={r.id}>
            <h3 style={{ margin: '0 0 8px', fontSize: 15 }}>{r.title}</h3>
            <p style={{ color: 'var(--muted-foreground)', fontSize: 12.5, lineHeight: 1.5, minHeight: 40 }}>{r.desc}</p>
            <Button
              variant="secondary"
              onClick={() => exportReport(r.id)}
              style={{
                background: 'rgba(59, 130, 246, 0.08)',
                borderColor: 'rgba(59, 130, 246, 0.2)',
                color: 'var(--primary-dark)',
                fontSize: 12.5,
                fontWeight: 600,
                display: 'flex',
                alignItems: 'center',
                gap: 6,
                padding: '6px 12px',
                borderRadius: 6,
                width: 'fit-content',
                boxShadow: 'none',
              }}
            >
              <svg style={{ width: 14, height: 14 }} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                <polyline points="7 10 12 15 17 10" />
                <line x1="12" y1="15" x2="12" y2="3" />
              </svg>
              Exportar CSV
            </Button>
          </Card>
        ))}
      </div>

      <Card>
        <h3 style={{ margin: '0 0 14px', fontSize: 15 }}>Vista previa · Académico general</h3>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 14 }}>
          <MiniStat label="Alumnos" value={STUDENTS.length} />
          <MiniStat label="Docentes" value={TEACHERS.length} />
          <MiniStat label="Grupos" value={GROUPS.length} />
          <MiniStat label="Promedio institucional" value={(STUDENTS.reduce((a, s) => a + s.promedio, 0) / STUDENTS.length).toFixed(1)} />
        </div>
        <div style={{ marginTop: 16, display: 'grid', gap: 8 }}>
          {GROUPS.map((g) => (
            <div key={g} style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12.5, padding: '8px 0', borderBottom: '1px solid var(--border)' }}>
              <span>{g}</span>
              <span style={{ color: 'var(--muted-foreground)' }}>
                Promedio {groupAverage(g).toFixed(1)} · Asistencia {groupAttendance(g)}%
              </span>
            </div>
          ))}
        </div>
      </Card>
    </div>
  )
}

function MiniStat({ label, value }: { label: string; value: string | number }) {
  return (
    <div style={{ background: '#f8fafb', borderRadius: 10, padding: 14 }}>
      <small style={{ display: 'block', color: 'var(--muted-foreground)', fontSize: 10 }}>{label}</small>
      <b style={{ fontSize: 18 }}>{value}</b>
    </div>
  )
}
