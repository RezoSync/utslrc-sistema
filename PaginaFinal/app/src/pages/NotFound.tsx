import { Icon } from '../components/Icon'

export default function NotFound({ onHome }: { onHome: () => void }) {
  return (
    <div style={{ minHeight: '100%', display: 'grid', placeItems: 'center', padding: 40 }}>
      <div style={{ textAlign: 'center', maxWidth: 420 }}>
        <div
          style={{
            width: 64,
            height: 64,
            borderRadius: 18,
            background: 'var(--secondary)',
            display: 'grid',
            placeItems: 'center',
            margin: '0 auto 22px',
          }}
        >
          <Icon name="search" size={28} style={{ color: 'var(--primary-dark)' }} />
        </div>
        <div style={{ fontSize: 46, fontWeight: 800, color: 'var(--primary)', lineHeight: 1, letterSpacing: -1, marginBottom: 10 }}>404</div>
        <h1 style={{ fontSize: 18, margin: '0 0 8px', color: 'var(--foreground)' }}>Esta página no existe</h1>
        <p style={{ fontSize: 13.5, color: 'var(--muted-foreground)', lineHeight: 1.65, margin: '0 0 26px' }}>
          Puede que el enlace esté roto, se haya movido, o que tu cuenta no tenga acceso a esta sección.
        </p>
        <button
          onClick={onHome}
          style={{
            background: 'var(--primary-action)',
            color: '#fff',
            border: 0,
            borderRadius: 10,
            padding: '10px 24px',
            fontWeight: 700,
            fontSize: 13.5,
            cursor: 'pointer',
          }}
        >
          Volver al inicio
        </button>
      </div>
    </div>
  )
}