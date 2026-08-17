import { CAREERS } from '../data/academic'
import { Card } from '../components/ui'

export default function Carreras() {
  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div>
        <h1 style={{ fontSize: 22, margin: 0 }}>Carreras</h1>
        <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>Oferta educativa institucional vigente.</p>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 16 }}>
        {CAREERS.map((c) => (
          <Card key={c.id}>
            <div style={{ fontSize: 11, fontWeight: 900, color: 'var(--primary-dark)', textTransform: 'uppercase' }}>{c.nivel}</div>
            <h3 style={{ margin: '10px 0 8px', fontSize: 17 }}>{c.nombre}</h3>
            <p style={{ color: 'var(--muted-foreground)', fontSize: 13, lineHeight: 1.6 }}>{c.descripcion}</p>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 9, marginTop: 14 }}>
              <div style={{ background: '#f8fafb', borderRadius: 10, padding: 10 }}>
                <small style={{ display: 'block', color: 'var(--muted-foreground)', fontSize: 10 }}>Duración</small>
                <b style={{ fontSize: 13 }}>{c.duracion}</b>
              </div>
              <div style={{ background: '#f8fafb', borderRadius: 10, padding: 10 }}>
                <small style={{ display: 'block', color: 'var(--muted-foreground)', fontSize: 10 }}>Modalidad</small>
                <b style={{ fontSize: 13 }}>{c.modalidad}</b>
              </div>
            </div>
          </Card>
        ))}
      </div>
    </div>
  )
}
