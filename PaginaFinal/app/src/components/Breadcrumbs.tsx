import { ChevronRight } from 'lucide-react'

export interface Crumb {
  label: string
  onClick?: () => void
}

/**
 * Breadcrumb minimalista para la parte superior de cada página.
 * No se muestra si solo hay 0 o 1 nivel (p. ej. en el Dashboard).
 */
export default function Breadcrumbs({ items }: { items: Crumb[] }) {
  if (items.length <= 1) return null

  return (
    <nav
      aria-label="Breadcrumb"
      style={{
        display: 'flex',
        alignItems: 'center',
        flexWrap: 'wrap',
        gap: 3,
        fontSize: 12,
        lineHeight: 1,
        marginBottom: 6,
      }}
    >
      {items.map((item, i) => {
        const isLast = i === items.length - 1
        return (
          <span key={i} style={{ display: 'flex', alignItems: 'center', gap: 3 }}>
            {item.onClick && !isLast ? (
              <button
                type="button"
                onClick={item.onClick}
                style={{
                  border: 0,
                  background: 'transparent',
                  padding: 0,
                  cursor: 'pointer',
                  fontSize: 12,
                  fontWeight: 500,
                  color: 'var(--muted-foreground)',
                  transition: 'color .15s ease',
                }}
                onMouseEnter={(e) => (e.currentTarget.style.color = 'var(--primary-dark)')}
                onMouseLeave={(e) => (e.currentTarget.style.color = 'var(--muted-foreground)')}
              >
                {item.label}
              </button>
            ) : (
              <span
                style={{
                  fontSize: 12,
                  fontWeight: isLast ? 600 : 500,
                  color: isLast ? 'var(--foreground)' : 'var(--muted-foreground)',
                }}
              >
                {item.label}
              </span>
            )}
            {!isLast && <ChevronRight size={12} strokeWidth={2.25} style={{ color: 'var(--border)', flexShrink: 0 }} />}
          </span>
        )
      })}
    </nav>
  )
}