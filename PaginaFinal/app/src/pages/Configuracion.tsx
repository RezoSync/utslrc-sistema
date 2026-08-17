import { useState } from 'react'
import type { Role } from '../types'
import { Card, Tabs, Button, Badge } from '../components/ui'

const USERS = [
  { name: 'Administrador Demo', role: 'Administrador' as Role, email: 'admin@utslrc.edu.mx' },
  { name: 'Control Escolar Demo', role: 'Control Escolar' as Role, email: 'controlescolar@utslrc.edu.mx' },
  { name: 'Docente Demo', role: 'Docente' as Role, email: 'docente@utslrc.edu.mx' },
  { name: 'Alumno Demo', role: 'Alumno' as Role, email: 'alumno@alumnos.utslrc.edu.mx' },
]

export default function Configuracion({ role }: { role: Role }) {
  const [tab, setTab] = useState('perfil')

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div>
        <h1 style={{ fontSize: 22, margin: 0 }}>Configuración</h1>
        <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>Perfil, usuarios, roles, permisos y configuración académica.</p>
      </div>

      <Card>
        <Tabs
          tabs={[
            { id: 'perfil', label: 'Perfil' },
            { id: 'usuarios', label: 'Usuarios' },
            { id: 'roles', label: 'Roles y permisos' },
            { id: 'academica', label: 'Configuración académica' },
          ]}
          active={tab}
          onChange={setTab}
        />

        {tab === 'perfil' && (
          <div style={{ maxWidth: 420, display: 'grid', gap: 12 }}>
            <Row label="Sesión activa" value={role} />
            <Row label="Institución" value="UTSLRC" />
            <Row label="Periodo" value="Enero – Abril 2025" />
            <Button variant="primary">Guardar cambios</Button>
          </div>
        )}

        {tab === 'usuarios' && (
          <div style={{ display: 'grid', gap: 10 }}>
            {USERS.map((u) => (
              <div key={u.email} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: 12, border: '1px solid var(--border)', borderRadius: 10 }}>
                <div>
                  <b style={{ fontSize: 13 }}>{u.name}</b>
                  <div style={{ fontSize: 11.5, color: 'var(--muted-foreground)' }}>{u.email}</div>
                </div>
                <Badge text={u.role} bg="var(--secondary)" color="var(--primary-dark)" />
              </div>
            ))}
          </div>
        )}

        {tab === 'roles' && (
          <div style={{ display: 'grid', gap: 10, fontSize: 12.5 }}>
            <p style={{ color: 'var(--muted-foreground)' }}>Permisos demo simplificados por rol. No se requiere autenticación real.</p>
            <Row label="Administrador / Control Escolar" value="Acceso total al sistema" />
            <Row label="Docente" value="Grupos, alumnos, calificaciones, asistencia, horarios, kardex" />
            <Row label="Alumno" value="Calificaciones y asistencia propias, horarios, biblioteca, servicios" />
          </div>
        )}

        {tab === 'academica' && (
          <div style={{ display: 'grid', gap: 12, maxWidth: 420 }}>
            <Row label="Ponderación evidencias" value="20%" />
            <Row label="Ponderación conocimiento" value="30%" />
            <Row label="Ponderación desempeño" value="20%" />
            <Row label="Ponderación actitud" value="10%" />
            <Row label="Ponderación examen" value="20%" />
          </div>
        )}
      </Card>
    </div>
  )
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, padding: '8px 0', borderBottom: '1px solid var(--border)' }}>
      <span style={{ color: 'var(--muted-foreground)' }}>{label}</span>
      <span style={{ fontWeight: 500 }}>{value}</span>
    </div>
  )
}
