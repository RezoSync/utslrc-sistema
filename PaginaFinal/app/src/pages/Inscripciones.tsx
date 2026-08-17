import { useMemo, useState } from 'react'
import { GROUPS, STUDENTS } from '../data/students'
import { CAREERS } from '../data/academic'
import { ENROLLMENTS } from '../data/enrollments'
import { Card, StatCard, Table, Badge, Select, Input } from '../components/ui'

const BAR_COLORS = ['var(--primary)', 'var(--navy)', 'var(--gold)', '#6d8fa8', '#9a6a00', '#a33b3b']

const STATUS_STYLE: Record<string, { bg: string; color: string }> = {
  Inscrito: { bg: '#f0faf4', color: '#15803d' },
  'Pendiente de pago': { bg: '#fff4dc', color: '#9a6a00' },
  Baja: { bg: '#fde9e9', color: '#a33b3b' },
}

export default function Inscripciones() {
  const [grupo, setGrupo] = useState(GROUPS[0])
  const [query, setQuery] = useState('')

  const porCarrera = useMemo(() => {
    const counts = new Map<string, number>()
    for (const s of STUDENTS) {
      if (s.status !== 'Activo') continue
      counts.set(s.carrera, (counts.get(s.carrera) ?? 0) + 1)
    }
    const list = CAREERS.map((c) => ({ nombre: c.nombre, siglas: c.siglas, count: counts.get(c.nombre) ?? 0 }))
    // Incluye carreras con alumnos que no coincidan con el catálogo (por si acaso)
    for (const [nombre, count] of counts) {
      if (!list.some((l) => l.nombre === nombre)) list.push({ nombre, siglas: nombre, count })
    }
    return list.sort((a, b) => b.count - a.count)
  }, [])

  const porCuatrimestre = useMemo(() => {
    const counts = new Map<string, number>()
    for (const s of STUDENTS) {
      if (s.status !== 'Activo') continue
      counts.set(s.cuatrimestre, (counts.get(s.cuatrimestre) ?? 0) + 1)
    }
    return [...counts.entries()].sort((a, b) => a[0].localeCompare(b[0]))
  }, [])

  const totalActivos = STUDENTS.filter((s) => s.status === 'Activo').length
  const maxCarrera = porCarrera[0]
  const maxCuatri = Math.max(1, ...porCuatrimestre.map(([, c]) => c))
  const maxCarreraCount = Math.max(1, ...porCarrera.map((c) => c.count))

  const rows = useMemo(() => {
    const ids = new Set(STUDENTS.filter((s) => s.grupo === grupo).map((s) => s.id))
    return ENROLLMENTS.filter((e) => ids.has(e.studentId)).filter(
      (e) => query.trim() === '' || e.materia.toLowerCase().includes(query.toLowerCase())
    )
  }, [grupo, query])

  const studentOf = (id: string) => STUDENTS.find((s) => s.id === id)!

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div>
        <h1 style={{ fontSize: 22, margin: 0 }}>Inscripciones</h1>
        <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>
          Distribución de alumnos activos por carrera y cuatrimestre, y estatus de inscripción por materia y periodo.
        </p>
      </div>

      <div className="rg-3" style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 14 }}>
        <StatCard label="Alumnos activos" value={totalActivos} icon="◍" tint="var(--secondary)" />
        <StatCard label="Carreras con inscritos" value={porCarrera.filter((c) => c.count > 0).length} icon="◈" tint="#eff6ff" />
        <StatCard label="Carrera con más inscritos" value={maxCarrera ? `${maxCarrera.count} · ${maxCarrera.siglas}` : '—'} icon="◔" tint="var(--gold-light)" />
      </div>

      <Card>
        <h2 style={{ fontSize: 15, margin: '0 0 4px' }}>Alumnos inscritos por carrera</h2>
        <p style={{ fontSize: 12, color: 'var(--muted-foreground)', margin: '0 0 20px' }}>Solo alumnos con status Activo.</p>
        <div style={{ display: 'grid', gap: 16 }}>
          {porCarrera.map((c, i) => (
            <div key={c.nombre}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 6, fontSize: 12.5 }}>
                <span style={{ fontWeight: 600 }}>{c.nombre}</span>
                <span style={{ color: 'var(--muted-foreground)' }}>
                  {c.count} alumno{c.count === 1 ? '' : 's'} · {totalActivos ? Math.round((c.count / totalActivos) * 100) : 0}%
                </span>
              </div>
              <div style={{ height: 12, background: 'var(--secondary)', borderRadius: 999, overflow: 'hidden' }}>
                <div
                  style={{
                    height: '100%',
                    width: `${(c.count / maxCarreraCount) * 100}%`,
                    background: BAR_COLORS[i % BAR_COLORS.length],
                    borderRadius: 999,
                    transition: 'width .3s ease',
                  }}
                />
              </div>
            </div>
          ))}
          {porCarrera.length === 0 && (
            <p style={{ fontSize: 13, color: 'var(--muted-foreground)', textAlign: 'center', padding: '20px 0' }}>
              Aún no hay alumnos registrados.
            </p>
          )}
        </div>
      </Card>

      <Card>
        <h2 style={{ fontSize: 15, margin: '0 0 4px' }}>Alumnos inscritos por cuatrimestre</h2>
        <p style={{ fontSize: 12, color: 'var(--muted-foreground)', margin: '0 0 20px' }}>Vista general sobre el avance académico de la matrícula activa.</p>
        <div style={{ display: 'flex', alignItems: 'flex-end', gap: 18, height: 180, padding: '0 4px' }}>
          {porCuatrimestre.map(([cuatri, count]) => (
            <div key={cuatri} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8, flex: 1 }}>
              <span style={{ fontSize: 12, fontWeight: 700 }}>{count}</span>
              <div
                style={{
                  width: '100%',
                  maxWidth: 46,
                  height: `${Math.max(6, (count / maxCuatri) * 130)}px`,
                  background: 'var(--primary)',
                  borderRadius: '6px 6px 0 0',
                }}
              />
              <span style={{ fontSize: 11.5, color: 'var(--muted-foreground)' }}>Cuatri. {cuatri}</span>
            </div>
          ))}
          {porCuatrimestre.length === 0 && (
            <p style={{ fontSize: 13, color: 'var(--muted-foreground)', margin: 'auto' }}>Sin datos disponibles.</p>
          )}
        </div>
      </Card>

      <Card>
        <h2 style={{ fontSize: 15, margin: '0 0 4px' }}>Inscripción por materia</h2>
        <p style={{ fontSize: 12, color: 'var(--muted-foreground)', margin: '0 0 16px' }}>Estatus de inscripción por materia y periodo, filtrable por grupo.</p>
        <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', marginBottom: 14 }}>
          <Select value={grupo} onChange={setGrupo} options={[...GROUPS]} />
          <Input value={query} onChange={setQuery} placeholder="Buscar materia…" style={{ minWidth: 240 }} />
        </div>
        <Table headers={['Alumno', 'Expediente', 'Materia', 'Periodo', 'Status']}>
          {rows.map((e) => (
            <tr key={e.id} style={{ borderBottom: '1px solid var(--border)' }}>
              <td style={{ padding: '10px 12px', fontWeight: 500 }}>{studentOf(e.studentId).nombre}</td>
              <td style={{ padding: '10px 12px', fontFamily: 'monospace', fontSize: 12 }}>{studentOf(e.studentId).expediente}</td>
              <td style={{ padding: '10px 12px' }}>{e.materia}</td>
              <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{e.periodo}</td>
              <td style={{ padding: '10px 12px' }}>
                <Badge text={e.status} bg={STATUS_STYLE[e.status].bg} color={STATUS_STYLE[e.status].color} />
              </td>
            </tr>
          ))}
        </Table>
      </Card>
    </div>
  )
}
