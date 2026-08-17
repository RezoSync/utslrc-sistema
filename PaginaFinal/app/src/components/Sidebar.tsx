import { useState } from 'react'
import type { PageId, Role } from '../types'
import { NAV, ROLE_PAGES } from '../nav'
import logoUtslrc from '../assets/logos/logo-utslrc.png'
import campusUtslrc from '../assets/campus-utslrc.png'
import { Icon } from './Icon'

interface Props {
  currentPage: PageId
  onNavigate: (page: PageId) => void
  role: Role
  onExit: () => void
  mobileOpen?: boolean
  onCloseMobile?: () => void
}

export default function Sidebar({ currentPage, onNavigate, role, onExit, mobileOpen, onCloseMobile }: Props) {
  const allowed = new Set(ROLE_PAGES[role])
  const [openGroups, setOpenGroups] = useState<Set<string>>(() => new Set(NAV.filter((group) => group.items.some((item) => item.id === currentPage)).map((group) => group.label)))
  const handleNavigate = (page: PageId) => {
    onNavigate(page)
    onCloseMobile?.()
  }
  return (
    <aside
      className={`app-sidebar${mobileOpen ? ' is-open' : ''}`}
      style={{
        width: 258,
        backgroundColor: 'var(--sidebar-bg)',
        backgroundImage: `linear-gradient(rgba(8,82,64,.94),rgba(8,82,64,.96)), url(${campusUtslrc})`,
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        borderRight: '1px solid var(--sidebar-border)',
        display: 'flex',
        flexDirection: 'column',
        flexShrink: 0,
        zIndex: 10,
      }}
    >
      <div style={{ padding: '20px 18px', borderBottom: '1px solid var(--sidebar-border)' }}>
        <div style={{ background: 'transparent', borderRadius: 10, padding: 8, display: 'inline-flex' }}>
          <img src={logoUtslrc} alt="UTSLRC" style={{ width: 150, height: 40, objectFit: 'contain' }} />
        </div>
        <div style={{ marginTop: 10, color: '#89a7b2', fontSize: 10, textTransform: 'uppercase', letterSpacing: '.12em' }}>
          Sistema Integral Universitario
        </div>
      </div>

      <nav style={{ flex: 1, padding: '12px 10px', overflowY: 'auto' }}>
        {NAV.map((group) => {
          const items = group.items.filter((i) => allowed.has(i.id))
          if (!items.length) return null
          const isOpen = openGroups.has(group.label)
          const toggleGroup = () => setOpenGroups((previous) => {
            const next = new Set(previous)
            if (next.has(group.label)) next.delete(group.label)
            else next.add(group.label)
            return next
          })
          return (
            <div key={group.label} className={`sidebar-group${isOpen ? ' is-open' : ''}`}>
              <button className="sidebar-group-toggle" onClick={toggleGroup} aria-expanded={isOpen} aria-controls={`sidebar-${group.label}`}>
                <span>{group.label}</span>
                <svg className="sidebar-group-chevron" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true"><path d="m6 9 6 6 6-6" /></svg>
              </button>
              <div id={`sidebar-${group.label}`} className="sidebar-group-items" hidden={!isOpen}>
              {items.map((item) => {
                const active = currentPage === item.id
                return (
                  <button
                    key={item.id}
                    className={`sidebar-nav-item${active ? ' is-active' : ''}`}
                    onClick={() => handleNavigate(item.id)}
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      gap: 10,
                      width: '100%',
                      padding: '10px 12px',
                      borderRadius: 9,
                      border: 'none',
                      background: active ? 'rgba(25,183,124,0.24)' : 'transparent',
                      color: active ? '#fff' : 'var(--sidebar-fg)',
                      fontWeight: active ? 700 : 500,
                      fontSize: 13,
                      cursor: 'pointer',
                      textAlign: 'left',
                      marginBottom: 2,
                    }}
                  >
                    <span style={{ width: 20, flexShrink: 0, display: 'grid', placeItems: 'center' }}><Icon name={item.icon} size={18} /></span>
                    <span style={{ whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{item.label}</span>
                  </button>
                )
              })}
              </div>
            </div>
          )
        })}
      </nav>

      <div style={{ padding: 14, borderTop: '1px solid var(--sidebar-border)' }}>
        <button
          onClick={onExit}
          style={{
            width: '100%',
            padding: '9px 0',
            borderRadius: 9,
            border: '1px solid var(--sidebar-border)',
            background: 'transparent',
            color: 'var(--sidebar-fg)',
            cursor: 'pointer',
            fontSize: 12.5,
            fontWeight: 600,
          }}
        >
          ↩ Portal público
        </button>
      </div>
    </aside>
  )
}
