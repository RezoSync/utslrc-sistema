import { useState, useEffect } from 'react'
import { BOOKS, LOANS } from '../data/biblioteca'
import { STUDENTS } from '../data/students'
import { Card, StatCard, Badge, Button, Input, Select, Table, Tabs, Modal, Toast, useToast } from '../components/ui'
import { libraryService, loadAppData } from '../services'
import { buscarLibrosGoogleBooks, type LibroGoogleBooks } from '../services/googleBooks'
import type { Role } from '../types'

const STATUS_STYLE: Record<'Vigente' | 'Vencido' | 'Devuelto', { bg: string; color: string }> = {
  Vigente: { bg: '#eff6ff', color: '#1d4ed8' },
  Vencido: { bg: '#fef2f2', color: '#b91c1c' },
  Devuelto: { bg: '#f0faf4', color: '#15803d' },
}

// Fecha mínima seleccionable para "fecha límite": debe ser mayor al día de hoy.
function manana(): string {
  const d = new Date()
  d.setDate(d.getDate() + 1)
  return d.toISOString().slice(0, 10)
}

interface Props {
  role?: Role
}

export default function Biblioteca({ role }: Props) {
  const esAdministrador = role === 'Administrador'
  // Sólo el rol Vinculación puede ver/gestionar préstamos.
  const puedeVerPrestamos = role === 'Vinculacion'
  const [tab, setTab] = useState('catalogo')
  const [query, setQuery] = useState('')
  const [tick, setTick] = useState(0)
  const [busy, setBusy] = useState(false)
  const { msg, show, fire } = useToast()

  // --- buscador Google Books ---
  const [mostrarBuscador, setMostrarBuscador] = useState(false)
  const [busquedaGoogle, setBusquedaGoogle] = useState('')
  const [resultadosGoogle, setResultadosGoogle] = useState<LibroGoogleBooks[]>([])
  const [cargandoBusqueda, setCargandoBusqueda] = useState(false)
  const [errorBusqueda, setErrorBusqueda] = useState('')

  // --- nuevo préstamo ---
  const [prestamoOpen, setPrestamoOpen] = useState(false)
  const [prestamoLibroId, setPrestamoLibroId] = useState('')
  const [prestamoAlumnoId, setPrestamoAlumnoId] = useState('')
  const [prestamoFechaLimite, setPrestamoFechaLimite] = useState('')
  const fechaMinima = manana()

  async function refresh() {
    await loadAppData()
    setTick((t) => t + 1)
  }

  const catalogoFiltrado = BOOKS.filter(
    (l) => query.trim() === '' || l.titulo.toLowerCase().includes(query.toLowerCase()) || l.autor.toLowerCase().includes(query.toLowerCase())
  )

  const vigentes = LOANS.filter((p) => p.status === 'Vigente').length
  const vencidos = LOANS.filter((p) => p.status === 'Vencido').length

  function handleBuscarGoogle(texto: string) {
    setBusquedaGoogle(texto)
    setErrorBusqueda('')
  }

  useEffect(() => {
    if (busquedaGoogle.trim().length < 2) {
      setResultadosGoogle([])
      return
    }
    const timeout = setTimeout(async () => {
      setCargandoBusqueda(true)
      try {
        const resultados = await buscarLibrosGoogleBooks(busquedaGoogle)
        setResultadosGoogle(resultados)
      } catch (err) {
        setErrorBusqueda(err instanceof Error ? err.message : 'Error al buscar en Google Books')
      } finally {
        setCargandoBusqueda(false)
      }
    }, 500)
    return () => clearTimeout(timeout)
  }, [busquedaGoogle])

  async function agregarAlCatalogo(libro: LibroGoogleBooks) {
    const yaExiste = BOOKS.some((l) => l.isbn === libro.isbn && libro.isbn !== '')
    if (yaExiste) {
      setErrorBusqueda('Este libro ya está en el catálogo.')
      return
    }
    setBusy(true)
    try {
      await libraryService.createBook({
        isbn: libro.isbn || null,
        titulo: libro.titulo,
        autor: libro.autor,
        categoria: libro.categoria,
        ejemplares: 1,
        portada: libro.portada || null,
        google_books_id: libro.googleBooksId,
      })
      await refresh()
      fire('Libro agregado al catálogo')
      setMostrarBuscador(false)
      setBusquedaGoogle('')
      setResultadosGoogle([])
    } catch (err) {
      setErrorBusqueda(err instanceof Error ? err.message : 'Error al guardar el libro')
    } finally {
      setBusy(false)
    }
  }

  function abrirPrestamo() {
    setPrestamoLibroId('')
    setPrestamoAlumnoId('')
    const enDosSemanas = new Date()
    enDosSemanas.setDate(enDosSemanas.getDate() + 14)
    setPrestamoFechaLimite(enDosSemanas.toISOString().slice(0, 10))
    setPrestamoOpen(true)
  }

  async function confirmarPrestamo() {
    if (!prestamoLibroId || !prestamoAlumnoId || !prestamoFechaLimite) return
    if (prestamoFechaLimite < fechaMinima) {
      fire('La fecha límite debe ser mayor al día de hoy')
      return
    }
    setBusy(true)
    try {
      await libraryService.createLoan({
        book_id: prestamoLibroId,
        student_id: prestamoAlumnoId,
        fecha_limite: prestamoFechaLimite,
      })
      await refresh()
      fire('Préstamo registrado')
      setPrestamoOpen(false)
    } catch (err) {
      fire(err instanceof Error ? err.message : 'Error al registrar el préstamo')
    } finally {
      setBusy(false)
    }
  }

  async function devolver(prestamoId: string) {
    setBusy(true)
    try {
      await libraryService.devolverLoan(prestamoId)
      await refresh()
      fire('Devolución registrada')
    } catch (err) {
      fire(err instanceof Error ? err.message : 'Error al procesar la devolución')
    } finally {
      setBusy(false)
    }
  }

  const librosDisponibles = BOOKS.filter((l) => l.disponibles > 0)

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div style={{ display: 'grid', gridTemplateColumns: puedeVerPrestamos ? 'repeat(4, 1fr)' : 'repeat(2, 1fr)', gap: 14 }}>
        <StatCard label="Títulos en acervo" value={BOOKS.length} icon="▨" tint="var(--secondary)" />
        <StatCard label="Ejemplares totales" value={BOOKS.reduce((s, l) => s + l.ejemplares, 0)} icon="▧" tint="var(--gold-light)" />
        {puedeVerPrestamos && (
          <>
            <StatCard label="Préstamos vigentes" value={vigentes} icon="◔" tint="#eff6ff" />
            <StatCard label="Préstamos vencidos" value={vencidos} icon="◈" tint="#fef2f2" />
          </>
        )}
      </div>

      <Card>
        <Tabs
          tabs={[
            { id: 'catalogo', label: 'Catálogo' },
            ...(puedeVerPrestamos ? [{ id: 'prestamos', label: 'Préstamos' }] : []),
          ]}
          active={tab}
          onChange={setTab}
        />

        {tab === 'catalogo' && (
          <>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 16, gap: 10, flexWrap: 'wrap' }}>
              <Input value={query} onChange={setQuery} placeholder="Buscar por título o autor…" style={{ minWidth: 260 }} />
              {esAdministrador && (
                <Button variant="primary" small onClick={() => setMostrarBuscador((v) => !v)}>
                  + Registrar título
                </Button>
              )}
            </div>

            {mostrarBuscador && (
              <Card style={{ marginBottom: 16, background: 'var(--secondary)' }}>
                <Input
                  value={busquedaGoogle}
                  onChange={handleBuscarGoogle}
                  placeholder="Buscar en Google Books por título, autor o ISBN…"
                  style={{ width: '100%', marginBottom: 12 }}
                />
                {cargandoBusqueda && <p style={{ fontSize: 13, color: 'var(--muted-foreground)' }}>Buscando…</p>}
                {errorBusqueda && <p style={{ fontSize: 13, color: '#b91c1c' }}>{errorBusqueda}</p>}
                <div style={{ display: 'flex', flexDirection: 'column', gap: 8, maxHeight: 320, overflowY: 'auto' }}>
                  {resultadosGoogle.map((libro) => (
                    <div
                      key={libro.googleBooksId}
                      style={{ display: 'flex', gap: 12, alignItems: 'center', padding: 8, background: '#fff', borderRadius: 7, border: '1px solid var(--border)' }}
                    >
                      {libro.portada ? (
                        <img src={libro.portada} alt={libro.titulo} style={{ width: 32, height: 46, objectFit: 'cover', borderRadius: 3 }} />
                      ) : (
                        <div style={{ width: 32, height: 46, background: 'var(--secondary)', borderRadius: 3, flexShrink: 0 }} />
                      )}
                      <div style={{ flex: 1, minWidth: 0 }}>
                        <div style={{ fontWeight: 500, fontSize: 13 }}>{libro.titulo}</div>
                        <div style={{ fontSize: 12, color: 'var(--muted-foreground)' }}>{libro.autor}</div>
                      </div>
                      <Button variant="secondary" small disabled={busy} onClick={() => agregarAlCatalogo(libro)}>
                        Agregar
                      </Button>
                    </div>
                  ))}
                </div>
              </Card>
            )}

            {catalogoFiltrado.length ? (
              <div
                style={{
                  display: 'grid',
                  gridTemplateColumns: 'repeat(auto-fill, minmax(168px, 1fr))',
                  gap: 20,
                }}
              >
                {catalogoFiltrado.map((l) => (
                  <div key={l.id} style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
                    <div
                      style={{
                        position: 'relative',
                        aspectRatio: '2 / 3',
                        borderRadius: 12,
                        overflow: 'hidden',
                        background: 'var(--secondary)',
                        boxShadow: '0 10px 26px rgba(19,42,56,.12)',
                      }}
                    >
                      {l.portada ? (
                        <img src={l.portada} alt={l.titulo} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                      ) : (
                        <div
                          style={{
                            width: '100%',
                            height: '100%',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            padding: 14,
                            textAlign: 'center',
                            color: 'var(--primary-dark)',
                            fontFamily: "'Barlow Condensed', sans-serif",
                            fontWeight: 700,
                            fontSize: 15,
                            lineHeight: 1.15,
                          }}
                        >
                          {l.titulo}
                        </div>
                      )}
                      <div style={{ position: 'absolute', top: 8, right: 8 }}>
                        <Badge
                          text={l.disponibles > 0 ? `${l.disponibles} disp.` : 'Agotado'}
                          bg={l.disponibles > 0 ? 'rgba(240,250,244,.95)' : 'rgba(254,242,242,.95)'}
                          color={l.disponibles > 0 ? '#15803d' : '#b91c1c'}
                        />
                      </div>
                    </div>
                    <div>
                      <div
                        style={{
                          fontWeight: 600,
                          fontSize: 13,
                          lineHeight: 1.3,
                          overflow: 'hidden',
                          textOverflow: 'ellipsis',
                          display: '-webkit-box',
                          WebkitLineClamp: 2,
                          WebkitBoxOrient: 'vertical',
                        }}
                      >
                        {l.titulo}
                      </div>
                      <div style={{ fontSize: 11.5, color: 'var(--muted-foreground)', marginTop: 2 }}>{l.autor}</div>
                      <div style={{ fontSize: 10.5, color: 'var(--muted-foreground)', marginTop: 3, textTransform: 'uppercase', letterSpacing: 0.3 }}>
                        {l.categoria}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <p style={{ padding: '18px 12px', textAlign: 'center', color: 'var(--muted-foreground)', fontSize: 13 }}>
                No hay libros{query ? ' que coincidan con la búsqueda' : ' registrados todavía'}.
              </p>
            )}
          </>
        )}

        {tab === 'prestamos' && puedeVerPrestamos && (
          <>
            <div style={{ display: 'flex', justifyContent: 'flex-end', marginBottom: 16 }}>
              <Button variant="primary" small onClick={abrirPrestamo}>+ Nuevo préstamo</Button>
            </div>
            <Table headers={['Folio', 'Libro', 'Alumno', 'Préstamo', 'Límite', 'Status', '']}>
              {LOANS.map((p) => (
                <tr key={p.id} style={{ borderBottom: '1px solid var(--border)' }}>
                  <td style={{ padding: '10px 12px', fontFamily: 'monospace', fontSize: 12 }}>{p.id}</td>
                  <td style={{ padding: '10px 12px', fontWeight: 500 }}>{p.libro}</td>
                  <td style={{ padding: '10px 12px' }}>{p.alumno}</td>
                  <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{p.fechaPrestamo}</td>
                  <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{p.fechaLimite}</td>
                  <td style={{ padding: '10px 12px' }}>
                    <Badge text={p.status} bg={STATUS_STYLE[p.status].bg} color={STATUS_STYLE[p.status].color} />
                  </td>
                  <td style={{ padding: '10px 12px' }}>
                    {p.status !== 'Devuelto' && (
                      <Button variant="ghost" small disabled={busy} onClick={() => devolver(p.id)}>
                        Marcar devuelto
                      </Button>
                    )}
                  </td>
                </tr>
              ))}
            </Table>
          </>
        )}
      </Card>

      {prestamoOpen && puedeVerPrestamos && (
        <Modal title="Nuevo préstamo" onClose={() => setPrestamoOpen(false)} width={440}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
            <div>
              <label style={{ fontSize: 12, color: 'var(--muted-foreground)', display: 'block', marginBottom: 4 }}>Libro</label>
              <Select
                value={prestamoLibroId}
                onChange={setPrestamoLibroId}
                options={[
                  { value: '', label: 'Selecciona un libro…' },
                  ...librosDisponibles.map((l) => ({ value: l.id, label: `${l.id} — ${l.titulo}` })),
                ]}
                style={{ width: '100%' }}
              />
              {prestamoLibroId === '' && <span style={{ fontSize: 11.5, color: 'var(--muted-foreground)' }}>Elige un libro con ejemplares disponibles</span>}
            </div>
            <div>
              <label style={{ fontSize: 12, color: 'var(--muted-foreground)', display: 'block', marginBottom: 4 }}>Alumno</label>
              <Select
                value={prestamoAlumnoId}
                onChange={setPrestamoAlumnoId}
                options={[
                  { value: '', label: 'Selecciona un alumno…' },
                  ...STUDENTS.map((s) => ({ value: s.id, label: `${s.expediente} — ${s.nombre}` })),
                ]}
                style={{ width: '100%' }}
              />
            </div>
            <div>
              <label style={{ fontSize: 12, color: 'var(--muted-foreground)', display: 'block', marginBottom: 4 }}>Fecha límite</label>
              <input
                type="date"
                value={prestamoFechaLimite}
                min={fechaMinima}
                onChange={(e) => setPrestamoFechaLimite(e.target.value)}
                style={{ padding: '8px 12px', borderRadius: 7, border: '1px solid var(--border)', fontSize: 13, width: '100%' }}
              />
              <span style={{ fontSize: 11.5, color: 'var(--muted-foreground)' }}>Debe ser posterior al día de hoy</span>
            </div>
            <Button
              variant="primary"
              disabled={busy || !prestamoLibroId || !prestamoAlumnoId || !prestamoFechaLimite || prestamoFechaLimite < fechaMinima}
              onClick={confirmarPrestamo}
            >
              Confirmar préstamo
            </Button>
          </div>
        </Modal>
      )}

      <Toast message={msg} show={show} />
    </div>
  )
}