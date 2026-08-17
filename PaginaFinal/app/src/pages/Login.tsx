import { useState } from 'react'
import { authService } from '../services/auth'
import type { AuthUser } from '../services/auth'
import { ApiError } from '../services/api'
import logoUtslrc from '../assets/logos/logo-utslrc.png'
import campusUtslrc from '../assets/campus-utslrc.png'

interface Props {
  onLogin: (user: AuthUser) => void
  onBackToPublic: () => void
}

export default function Login({ onLogin, onBackToPublic }: Props) {
  const [user, setUser] = useState('')
  const [pass, setPass] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)
    setLoading(true)
    try {
      const authUser = await authService.login(user.trim(), pass)
      onLogin(authUser)
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'No se pudo iniciar sesión.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div
      style={{
        minHeight: '100vh',
        backgroundImage: `linear-gradient(120deg,rgba(8,77,61,.94),rgba(13,142,99,.78)), url(${campusUtslrc})`,
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        display: 'grid',
        placeItems: 'center',
        padding: 20,
      }}
    >
      <div style={{ width: 'min(440px,100%)', background: '#fff', borderRadius: 22, padding: 34, boxShadow: '0 30px 100px rgba(0,0,0,.22)' }}>
        <img src={logoUtslrc} alt="UTSLRC" style={{ width: 220, height: 64, objectFit: 'contain', display: 'block', margin: '0 auto 20px' }} />
        <h1 style={{ textAlign: 'center', fontSize: 22, margin: 0 }}>Acceso al sistema</h1>
        <p style={{ textAlign: 'center', color: 'var(--muted-foreground)', fontSize: 12, margin: '6px 0 0' }}>
          Universidad Tecnológica de San Luis Río Colorado
        </p>

        <form onSubmit={handleSubmit}>
          <div style={{ margin: '18px 0 14px' }}>
            <label style={{ display: 'block', fontSize: 11, fontWeight: 700, marginBottom: 7 }}>Usuario</label>
            <input
              value={user}
              onChange={(e) => setUser(e.target.value)}
              placeholder="Usuario institucional o número de expediente"
              autoComplete="username"
              style={{ width: '100%', padding: 12, border: '1px solid var(--border)', borderRadius: 10, fontSize: 13.5 }}
            />
          </div>
          <div style={{ margin: '14px 0' }}>
            <label style={{ display: 'block', fontSize: 11, fontWeight: 700, marginBottom: 7 }}>Contraseña</label>
            <input
              type="password"
              value={pass}
              onChange={(e) => setPass(e.target.value)}
              placeholder="••••••••"
              autoComplete="current-password"
              style={{ width: '100%', padding: 12, border: '1px solid var(--border)', borderRadius: 10, fontSize: 13.5 }}
            />
          </div>

          {error && (
            <div style={{ background: '#fdecec', border: '1px solid #f3b9b9', color: '#a33', borderRadius: 10, padding: 10, fontSize: 12.5, marginBottom: 14 }}>
              {error}
            </div>
          )}

          <button
            type="submit"
            disabled={loading || !user || !pass}
            style={{
              width: '100%',
              background: 'var(--primary)',
              color: '#fff',
              border: 'none',
              borderRadius: 11,
              padding: 13,
              fontWeight: 700,
              fontSize: 14,
              cursor: loading ? 'default' : 'pointer',
              opacity: loading || !user || !pass ? 0.7 : 1,
            }}
          >
            {loading ? 'Iniciando sesión…' : 'Iniciar sesión'}
          </button>
        </form>

        <button
          onClick={onBackToPublic}
          style={{ width: '100%', marginTop: 14, background: 'transparent', border: 'none', color: 'var(--muted-foreground)', fontSize: 12.5, cursor: 'pointer' }}
        >
          ← Volver al portal público
        </button>
      </div>
    </div>
  )
}
