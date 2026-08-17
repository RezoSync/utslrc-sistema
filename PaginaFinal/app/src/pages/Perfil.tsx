import { STUDENTS } from '../data/students'
import { TEACHERS } from '../data/teachers'
import { Card, Badge, Button } from '../components/ui'
import type { Role } from '../types'

interface Props {
  role: Role
  studentId?: string | null
  teacherId?: string | null
  onExit: () => void
}

function initials(text: string) {
  return text.split(' ').filter(Boolean).map((w) => w[0]).join('').slice(0, 2).toUpperCase()
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, padding: '10px 0', borderBottom: '1px solid var(--border)' }}>
      <span style={{ color: 'var(--muted-foreground)' }}>{label}</span>
      <span style={{ fontWeight: 600 }}>{value}</span>
    </div>
  )
}

export default function Perfil({ role, studentId, teacherId, onExit }: Props) {
  const student = role === 'Alumno' ? STUDENTS.find((s) => s.id === studentId) : undefined
  const teacher = role === 'Docente' ? TEACHERS.find((t) => t.id === teacherId) : undefined

  const displayName = student?.nombre ?? teacher?.nombre ?? role
  const displayEmail = student?.email ?? teacher?.email ?? '—'

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20, maxWidth: 760 }}>
      <div>
        <h1 style={{ fontSize: 22, margin: 0 }}>Mi perfil</h1>
        <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>Datos de tu cuenta y sesión activa.</p>
      </div>

      <Card>
        <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginBottom: 20 }}>
          <div
            style={{
              width: 60,
              height: 60,
              borderRadius: '50%',
              background: 'var(--primary)',
              color: '#fff',
              display: 'grid',
              placeItems: 'center',
              fontWeight: 800,
              fontSize: 20,
              flexShrink: 0,
            }}
          >
            {initials(displayName)}
          </div>
          <div>
            <h2 style={{ fontSize: 17, margin: '0 0 6px' }}>{displayName}</h2>
            <Badge text={role} bg="var(--secondary)" color="var(--primary-dark)" />
          </div>
        </div>

        <div style={{ display: 'grid', gap: 0 }}>
          <InfoRow label="Correo" value={displayEmail} />
          <InfoRow label="Institución" value="UTSLRC" />

          {student && (
            <>
              <InfoRow label="Expediente" value={student.expediente} />
              <InfoRow label="Carrera" value={student.carrera} />
              <InfoRow label="Grupo" value={student.grupo} />
              <InfoRow label="Cuatrimestre" value={student.cuatrimestre} />
              <InfoRow label="Periodo" value={student.periodo} />
              <InfoRow label="Promedio" value={student.promedio.toFixed(1)} />
              <InfoRow label="Asistencia" value={`${student.asistencia}%`} />
              <InfoRow label="Status" value={student.status} />
            </>
          )}

          {teacher && (
            <>
              <InfoRow label="Grado académico" value={teacher.grado} />
              <InfoRow label="Materias" value={teacher.materias.join(', ') || '—'} />
              <InfoRow label="Grupos asignados" value={teacher.grupos.join(', ') || '—'} />
            </>
          )}

          {!student && !teacher && <InfoRow label="Sesión" value="Cuenta administrativa" />}
        </div>
      </Card>

      <div>
        <Button variant="secondary" onClick={onExit}>
          Cerrar sesión
        </Button>
      </div>
    </div>
  )
}