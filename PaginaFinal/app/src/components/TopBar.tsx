import { useEffect, useRef, useState } from 'react'
import { Menu } from 'lucide-react'
import type { PageId, Role } from '../types'
import Breadcrumbs, { type Crumb } from './Breadcrumbs'

interface Props {
  title: string
  subtitle: string
  role: Role
  nombre: string
  crumbs?: Crumb[]
  onNavigate: (page: PageId) => void
  onExit: () => void
  onToggleSidebar?: () => void
}

function initials(nombre: string, role: string) {
  const source = nombre.trim() || role
  return source.split(' ').filter(Boolean).map((w) => w[0]).join('').slice(0, 2).toUpperCase()
}

export default function TopBar({ title, subtitle, role, nombre, crumbs, onNavigate, onExit, onToggleSidebar }: Props) {
  const [open, setOpen] = useState(false)
  const ref = useRef<HTMLDivElement>(null)

  useEffect(() => {
    function onClickOutside(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false)
    }
    document.addEventListener('mousedown', onClickOutside)
    return () => document.removeEventListener('mousedown', onClickOutside)
  }, [])

  return (
    <header
      style={{
        minHeight: 68,
        borderBottom: '1px solid var(--border)',
        background: '#fff',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: '12px 26px',
        flexShrink: 0,
        position: 'sticky',
        top: 0,
        zIndex: 5,
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: 12, minWidth: 0 }}>
        <button
          type="button"
          className="hamburger-btn"
          onClick={onToggleSidebar}
          aria-label="Abrir menú"
          style={{
            alignItems: 'center',
            justifyContent: 'center',
            width: 38,
            height: 38,
            borderRadius: 9,
            border: '1px solid var(--border)',
            background: 'transparent',
            color: 'var(--foreground)',
            cursor: 'pointer',
            flexShrink: 0,
          }}
        >
          <Menu size={20} />
        </button>
        <div style={{ minWidth: 0 }}>
          {crumbs && <Breadcrumbs items={crumbs} />}
          <h1 style={{ fontSize: 24, fontWeight: 700, color: 'var(--foreground)', margin: 0, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{title}</h1>
          {subtitle && <p style={{ fontSize: 12, color: 'var(--muted-foreground)', margin: '3px 0 0' }}>{subtitle}</p>}
        </div>
      </div>

      <div ref={ref} style={{ position: 'relative' }}>
        <button
          onClick={() => setOpen((v) => !v)}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: 12,
            background: 'transparent',
            border: 0,
            cursor: 'pointer',
            padding: '4px 6px',
            borderRadius: 10,
          }}
        >
          <div
            style={{
              width: 36,
              height: 36,
              borderRadius: '50%',
              background: 'var(--primary)',
              color: '#fff',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 700,
              fontSize: 13,
              flexShrink: 0,
            }}
          >
            {initials(nombre, role)}
          </div>
          <div style={{ lineHeight: 1.2, textAlign: 'left' }}>
            <div style={{ fontSize: 12.5, fontWeight: 700, maxWidth: 170, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
              {nombre || role}
            </div>
            <div style={{ fontSize: 10.5, color: 'var(--muted-foreground)' }}>{role}</div>
          </div>
        </button>

        {open && (
          <div
            style={{
              position: 'absolute',
              top: 'calc(100% + 8px)',
              right: 0,
              background: '#fff',
              border: '1px solid var(--border)',
              borderRadius: 12,
              boxShadow: '0 12px 28px rgba(15,35,45,.12)',
              minWidth: 200,
              overflow: 'hidden',
              zIndex: 20,
            }}
          >
            <button
              onClick={() => {
                setOpen(false)
                onNavigate('perfil')
              }}
              style={{
                width: '100%',
                textAlign: 'left',
                padding: '11px 16px',
                border: 0,
                background: 'transparent',
                fontSize: 13,
                fontWeight: 600,
                cursor: 'pointer',
              }}
            >
              Ver perfil
            </button>
            <div style={{ height: 1, background: 'var(--border)' }} />
            <button
              onClick={() => {
                setOpen(false)
                onExit()
              }}
              style={{
                width: '100%',
                textAlign: 'left',
                padding: '11px 16px',
                border: 0,
                background: 'transparent',
                fontSize: 13,
                fontWeight: 600,
                color: '#b42318',
                cursor: 'pointer',
              }}
            >
              Cerrar sesión
            </button>
          </div>
        )}
      </div>
    </header>
  )
}