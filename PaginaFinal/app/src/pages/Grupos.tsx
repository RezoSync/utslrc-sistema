import { GROUPS_DATA, studentsByGroup, groupAverage, groupAttendance } from '../data/groups'
import { Card, Button } from '../components/ui'

interface Props {
  onOpenGroup: (grupo: string) => void
}

export default function Grupos({ onOpenGroup }: Props) {
  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 20 }}>
        <div>
          <h1 style={{ fontSize: 22, margin: 0 }}>Grupos</h1>
          <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>
            Grupos activos de Tecnologías de la Información — periodo Enero – Abril 2025.
          </p>
        </div>
        <Button variant="primary" small>
          + Nuevo grupo
        </Button>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 16 }}>
        {GROUPS_DATA.map((g) => {
          const alumnos = studentsByGroup(g.nombre)
          const promedio = groupAverage(g.nombre)
          const asistencia = groupAttendance(g.nombre)
          return (
            <Card key={g.id}>
              <div style={{ fontSize: 11, fontWeight: 900, color: 'var(--primary-dark)', textTransform: 'uppercase' }}>
                {g.carrera} · {g.cuatrimestre}
              </div>
              <h3 style={{ margin: '8px 0 2px', fontSize: 18 }}>{g.nombre}</h3>
              <span style={{ color: 'var(--muted-foreground)', fontSize: 12 }}>{g.periodo}</span>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10, margin: '16px 0' }}>
                <div style={{ background: '#f8fafb', borderRadius: 10, padding: 10 }}>
                  <small style={{ display: 'block', color: 'var(--muted-foreground)', fontSize: 10 }}>Alumnos</small>
                  <b style={{ fontSize: 15 }}>{alumnos.length}</b>
                </div>
                <div style={{ background: '#f8fafb', borderRadius: 10, padding: 10 }}>
                  <small style={{ display: 'block', color: 'var(--muted-foreground)', fontSize: 10 }}>Promedio</small>
                  <b style={{ fontSize: 15 }}>{promedio.toFixed(1)}</b>
                </div>
                <div style={{ background: '#f8fafb', borderRadius: 10, padding: 10 }}>
                  <small style={{ display: 'block', color: 'var(--muted-foreground)', fontSize: 10 }}>Asistencia</small>
                  <b style={{ fontSize: 15 }}>{asistencia}%</b>
                </div>
                <div style={{ background: '#f8fafb', borderRadius: 10, padding: 10 }}>
                  <small style={{ display: 'block', color: 'var(--muted-foreground)', fontSize: 10 }}>Aula</small>
                  <b style={{ fontSize: 15 }}>{g.aula}</b>
                </div>
              </div>
              <Button variant="primary" onClick={() => onOpenGroup(g.nombre)}>
                Abrir grupo
              </Button>
            </Card>
          )
        })}
      </div>
    </div>
  )
}
