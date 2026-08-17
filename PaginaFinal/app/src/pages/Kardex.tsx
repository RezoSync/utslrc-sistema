import { useEffect, useMemo, useState } from 'react'
import { STUDENTS } from '../data/students'
import { LETTER_GRADE_INFO } from '../data/grades'
import { Card, Input, Table, Badge, Button } from '../components/ui'
import { gradeService, type KardexResponse } from '../services'
import { ApiError } from '../services/api'
import type { Role } from '../types'

interface Props {
  role?: Role
  studentId?: string | null
}

export default function Kardex({ role, studentId }: Props) {
  const isSelf = role === 'Alumno'
  const ownStudent = isSelf ? STUDENTS.find((s) => s.id === studentId) : undefined
  const [query, setQuery] = useState('')
  const [selected, setSelected] = useState(ownStudent ?? STUDENTS[0])
  const [kardex, setKardex] = useState<KardexResponse | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const results = useMemo(
    () => STUDENTS.filter((s) => query.trim() === '' || s.nombre.toLowerCase().includes(query.toLowerCase()) || s.expediente.includes(query)).slice(0, 8),
    [query]
  )

  const selectStudent = (s: (typeof STUDENTS)[number]) => {
    setSelected(s)
    setKardex(null)
    setError('')
  }

  const generar = async (id = selected.id) => {
    setLoading(true)
    setError('')
    try {
      const data = await gradeService.kardex(id)
      setKardex(data)
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'No se pudo generar el kardex.')
    } finally {
      setLoading(false)
    }
  }

  // Un alumno ve directamente su propio kardex, generado automáticamente.
  useEffect(() => {
    if (isSelf && ownStudent) {
      setSelected(ownStudent)
      generar(ownStudent.id)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isSelf, ownStudent?.id])

  if (isSelf && !ownStudent) {
    return (
      <div style={{ padding: 24 }}>
        <Card>
          <p style={{ fontSize: 13, color: 'var(--muted-foreground)', margin: 0 }}>
            No se encontró tu expediente de alumno. Contacta a Servicios Escolares.
          </p>
        </Card>
      </div>
    )
  }

  return (
    <div className="kardex-page" style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div>
        <h1 style={{ fontSize: 22, margin: 0 }}>{isSelf ? '' : 'Kardex'}</h1>
        <p style={{ color: 'var(--muted-foreground)', fontSize: 13, margin: '6px 0 0' }}>
          Historial académico oficial{isSelf ? '' : ' por alumno'}, generado directamente desde la base de datos.
        </p>
      </div>

      <div className="kardex-layout" style={{ display: 'grid', gridTemplateColumns: isSelf ? '1fr' : '280px 1fr', gap: 16, alignItems: 'start' }}>
        {!isSelf && (
          <Card style={{}}>
            <Input value={query} onChange={setQuery} placeholder="Buscar alumno…" style={{ width: '100%', marginBottom: 12 }} />
            <div style={{ display: 'grid', gap: 6, maxHeight: 420, overflowY: 'auto' }}>
              {results.map((s) => (
                <button
                  key={s.id}
                  onClick={() => selectStudent(s)}
                  style={{
                    textAlign: 'left',
                    border: 'none',
                    borderRadius: 9,
                    padding: '9px 10px',
                    background: selected.id === s.id ? 'var(--secondary)' : 'transparent',
                    cursor: 'pointer',
                  }}
                >
                  <div style={{ fontSize: 12.5, fontWeight: 600 }}>{s.nombre}</div>
                  <div style={{ fontSize: 11, color: 'var(--muted-foreground)' }}>{s.expediente} · {s.grupo}</div>
                </button>
              ))}
            </div>
          </Card>
        )}

        <Card style={{}}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 16, gap: 12, flexWrap: 'wrap' }}>
            <div>
              <h2 style={{ fontSize: 17, margin: 0 }}>{selected.nombre}</h2>
              <p style={{ color: 'var(--muted-foreground)', fontSize: 12.5, margin: '4px 0 0' }}>
                Exp. {selected.expediente} · {selected.grupo} · {selected.carrera}
              </p>
            </div>
            <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
              <Badge text={selected.status} bg="#f0faf4" color="#15803d" />
              {!isSelf && (
                <Button variant="primary" small onClick={() => generar()}>
                  {loading ? 'Generando…' : 'Generar kardex'}
                </Button>
              )}
              {kardex && (
                <Button variant="secondary" small onClick={() => window.print()}>
                  Imprimir
                </Button>
              )}
            </div>
          </div>

          {error && (
            <div style={{ padding: '10px 14px', borderRadius: 10, background: '#fdeeee', color: '#b42318', fontSize: 12.5, marginBottom: 16 }}>
              {error}
            </div>
          )}

          {loading && !kardex && (
            <div style={{ padding: '40px 20px', textAlign: 'center', color: 'var(--muted-foreground)', fontSize: 13 }}>
              Generando kardex…
            </div>
          )}

          {!kardex && !error && !loading && !isSelf && (
            <div style={{ padding: '40px 20px', textAlign: 'center', color: 'var(--muted-foreground)', fontSize: 13 }}>
              Selecciona un alumno y presiona <b>Generar kardex</b> para consultar su historial académico oficial.
            </div>
          )}

          {kardex && (
            <div style={{ display: 'grid', gap: 22 }}>
              <div className="rg-4" style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 12 }}>
                <SummaryStat label="Promedio general" value={kardex.resumen.promedioGeneral.toFixed(1)} />
                <SummaryStat label="Materias cursadas" value={String(kardex.resumen.totalMaterias)} />
                <SummaryStat label="Acreditadas" value={String(kardex.resumen.acreditadas)} />
                <SummaryStat label="No acreditadas" value={String(kardex.resumen.noAcreditadas)} />
              </div>

              {kardex.cuatrimestres.length === 0 && (
                <div style={{ padding: '20px 0', textAlign: 'center', color: 'var(--muted-foreground)', fontSize: 13 }}>
                  {isSelf ? 'Aún no tienes calificaciones registradas.' : 'Este alumno aún no tiene calificaciones registradas.'}
                </div>
              )}

              {kardex.cuatrimestres.map((c) => (
                <div key={c.cuatrimestre}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 8 }}>
                    <h3 style={{ fontSize: 14, margin: 0 }}>Cuatrimestre {c.cuatrimestre} · {c.periodo}</h3>
                    <span style={{ fontSize: 12, color: 'var(--muted-foreground)' }}>Promedio: <b style={{ color: 'var(--foreground)' }}>{c.promedio.toFixed(1)}</b></span>
                  </div>
                  <Table headers={['Materia', 'Créditos', 'Parcial', 'Final', 'Acreditación']}>
                    {c.materias.map((m) => (
                      <tr key={`${m.subjectId}-${m.parcial}`} style={{ borderBottom: '1px solid var(--border)' }}>
                        <td style={{ padding: '10px 12px' }}>{m.materia}</td>
                        <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{m.creditos}</td>
                        <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{m.parcial}</td>
                        <td style={{ padding: '10px 12px', fontWeight: 700 }}>{m.final}</td>
                        <td style={{ padding: '10px 12px' }}>
                          <Badge text={m.letra} bg={LETTER_GRADE_INFO[m.letra].bg} color={LETTER_GRADE_INFO[m.letra].color} />
                        </td>
                      </tr>
                    ))}
                  </Table>
                </div>
              ))}

              <p style={{ fontSize: 11, color: 'var(--muted-foreground)', margin: 0 }}>
                Generado el {new Date(kardex.generadoEn).toLocaleString('es-MX')} · NA menor a 8.0 · SA 8.0–8.9 · DE 9.0–9.6 · AU 9.7–10
              </p>
            </div>
          )}
        </Card>
      </div>
    </div>
  )
}
function SummaryStat({ label, value }: { label: string; value: string }) {
  return (
    <div style={{ border: '1px solid var(--border)', borderRadius: 12, padding: '14px 16px' }}>
      <b style={{ display: 'block', fontSize: 19, fontWeight: 700 }}>{value}</b>
      <span style={{ fontSize: 11.5, color: 'var(--muted-foreground)' }}>{label}</span>
    </div>
  )
}
