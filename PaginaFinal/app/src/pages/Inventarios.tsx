import { useEffect, useMemo, useRef, useState } from 'react'
import { QRCodeSVG } from 'qrcode.react'
import QRCode from 'qrcode'
import { jsPDF } from 'jspdf'
import { Html5Qrcode } from 'html5-qrcode'
import { Card, StatCard, Badge, Button, Input, Table, Modal, Select, Toast, useToast } from '../components/ui'
import { inventoryService } from '../services'
import { ApiError } from '../services/api'

interface Activo {
  id: string
  nombre: string
  categoria: string
  ubicacion: string | null
  responsable: string | null
  status: 'Disponible' | 'En uso' | 'Prestado' | 'En reparación' | 'Baja'
  valor: string | null
  qr: string
}

const STATUS_OPTIONS: Activo['status'][] = ['Disponible', 'En uso', 'Prestado', 'En reparación', 'Baja']

const STATUS_STYLES: Record<Activo['status'], { bg: string; color: string }> = {
  Disponible: { bg: '#f0faf4', color: '#15803d' },
  'En uso': { bg: '#eff6ff', color: '#1d4ed8' },
  Prestado: { bg: '#fefce8', color: '#a16207' },
  'En reparación': { bg: '#fff7ed', color: '#c2410c' },
  Baja: { bg: '#fef2f2', color: '#b91c1c' },
}

const DEFAULT_STATUS_STYLE = { bg: '#f1f5f9', color: '#475569' }

function statusStyle(status: string) {
  return STATUS_STYLES[status as Activo['status']] ?? DEFAULT_STATUS_STYLE
}

export default function Inventarios() {
  const [activos, setActivos] = useState<Activo[]>([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState('')
  const [query, setQuery] = useState('')
  const [scanCode, setScanCode] = useState('')
  const [scanResult, setScanResult] = useState<Activo | null | 'not-found'>(null)
  const [cameraOpen, setCameraOpen] = useState(false)

  const [formOpen, setFormOpen] = useState(false)
  const [editing, setEditing] = useState<Activo | null>(null)
  const [busy, setBusy] = useState(false)

  // --- Códigos QR: ver individual / descargar en PDF individual o en lote ---
  const [qrViewing, setQrViewing] = useState<Activo | null>(null)
  const [selected, setSelected] = useState<Set<string>>(new Set())
  const [generandoPdf, setGenerandoPdf] = useState(false)

  const { msg, show, fire } = useToast()

  async function refresh() {
    setLoading(true)
    setLoadError('')
    try {
      const rows = await inventoryService.getAll()
      setActivos(rows as Activo[])
    } catch (err) {
      setLoadError(err instanceof ApiError ? err.message : 'No se pudo cargar el inventario')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    refresh()
  }, [])

  // Mantiene sincronizado el resultado del escáner con la lista real de activos:
  // si lo editaste desde ahí, refleja el nuevo estado; si lo eliminaste, lo limpia.
  useEffect(() => {
    if (scanResult && scanResult !== 'not-found') {
      const updated = activos.find((a) => a.id === scanResult.id)
      setScanResult(updated ?? null)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activos])

  const filtered = useMemo(
    () =>
      activos.filter(
        (a) =>
          query.trim() === '' ||
          a.nombre.toLowerCase().includes(query.toLowerCase()) ||
          a.id.toLowerCase().includes(query.toLowerCase())
      ),
    [activos, query]
  )

  async function runScan(code: string) {
    if (!code.trim()) return
    try {
      const found = await inventoryService.scan(code.trim())
      setScanResult(found as Activo)
    } catch {
      setScanResult('not-found')
    }
  }

  function abrirCamara() {
    setCameraOpen(true)
  }

  function onCameraDecoded(text: string) {
    setCameraOpen(false)
    setScanCode(text)
    runScan(text)
  }

  const stats = {
    total: activos.length,
    disponibles: activos.filter((a) => a.status === 'Disponible').length,
    enUso: activos.filter((a) => a.status === 'En uso' || a.status === 'Prestado').length,
    reparacion: activos.filter((a) => a.status === 'En reparación').length,
  }

  function openCreate() {
    setEditing(null)
    setFormOpen(true)
  }

  function openEdit(a: Activo) {
    setEditing(a)
    setFormOpen(true)
  }

  async function handleSubmit(payload: Record<string, unknown>) {
    setBusy(true)
    try {
      if (editing) {
        await inventoryService.update(editing.id, payload)
        fire('Activo actualizado correctamente')
      } else {
        await inventoryService.create(payload)
        fire('Activo registrado correctamente')
      }
      setFormOpen(false)
      await refresh()
    } catch (err) {
      fire(err instanceof ApiError ? err.message : 'No se pudo guardar el activo')
    } finally {
      setBusy(false)
    }
  }

  async function handleDelete(a: Activo) {
    if (!confirm(`¿Dar de baja el activo "${a.nombre}" (${a.id})? Esta acción no se puede deshacer.`)) return
    setBusy(true)
    try {
      await inventoryService.remove(a.id)
      fire('Activo eliminado')
      await refresh()
    } catch (err) {
      fire(err instanceof ApiError ? err.message : 'No se pudo eliminar el activo')
    } finally {
      setBusy(false)
    }
  }

  function toggleSelect(id: string) {
    setSelected((prev) => {
      const next = new Set(prev)
      if (next.has(id)) next.delete(id)
      else next.add(id)
      return next
    })
  }

  function toggleSelectAll() {
    setSelected((prev) => (prev.size === filtered.length ? new Set() : new Set(filtered.map((a) => a.id))))
  }

  // Genera un PDF con una etiqueta por activo (QR + nombre + folio), lista para
  // imprimir y pegar en el equipo. Usa `qrcode` para rasterizar cada QR como PNG
  // (no depende del DOM) y `jspdf` para armar la hoja en una cuadrícula.
  async function descargarQR(items: Activo[]) {
    if (!items.length || generandoPdf) return
    setGenerandoPdf(true)
    try {
      const doc = new jsPDF({ unit: 'mm', format: 'letter' })
      const pageW = doc.internal.pageSize.getWidth()
      const pageH = doc.internal.pageSize.getHeight()
      const margin = 12
      const cols = 3
      const rows = 4
      const cellW = (pageW - margin * 2) / cols
      const cellH = (pageH - margin * 2) / rows
      const qrSize = Math.min(cellW, cellH) * 0.55

      for (let i = 0; i < items.length; i++) {
        const activo = items[i]
        const perPage = cols * rows
        const posInPage = i % perPage
        if (i > 0 && posInPage === 0) doc.addPage()

        const col = posInPage % cols
        const row = Math.floor(posInPage / cols)
        const cellX = margin + col * cellW
        const cellY = margin + row * cellH

        const qrDataUrl = await QRCode.toDataURL(activo.qr, { width: 300, margin: 1 })

        const qrX = cellX + (cellW - qrSize) / 2
        const qrY = cellY + 4
        doc.setDrawColor(200)
        doc.rect(cellX + 2, cellY + 2, cellW - 4, cellH - 4)
        doc.addImage(qrDataUrl, 'PNG', qrX, qrY, qrSize, qrSize)

        doc.setFontSize(9)
        doc.setFont('helvetica', 'bold')
        const nombreLines = doc.splitTextToSize(activo.nombre, cellW - 8)
        doc.text(nombreLines, cellX + cellW / 2, qrY + qrSize + 5, { align: 'center' })

        doc.setFontSize(8)
        doc.setFont('helvetica', 'normal')
        doc.text(activo.id, cellX + cellW / 2, qrY + qrSize + 5 + nombreLines.length * 3.6, { align: 'center' })
      }

      const nombreArchivo =
        items.length === 1 ? `qr-${items[0].id}.pdf` : `qr-inventario-${new Date().toISOString().slice(0, 10)}.pdf`
      doc.save(nombreArchivo)
    } catch {
      fire('No se pudo generar el PDF de códigos QR')
    } finally {
      setGenerandoPdf(false)
    }
  }

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))', gap: 14 }}>
        <StatCard label="Activos registrados" value={stats.total} icon="▩" tint="var(--secondary)" />
        <StatCard label="Disponibles" value={stats.disponibles} icon="✓" tint="#f0faf4" />
        <StatCard label="En uso / prestado" value={stats.enUso} icon="◔" tint="#eff6ff" />
        <StatCard label="En reparación" value={stats.reparacion} icon="◈" tint="#fff7ed" />
      </div>

      {/* Scanner - pantalla de laboratorio */}
      <Card style={{ background: 'linear-gradient(135deg, var(--primary) 0%, #123a7a 100%)', color: '#fff' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 20, flexWrap: 'wrap' }}>
          <div>
            <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 4 }}>Escáner de equipo — Pantalla de Laboratorio</div>
            <div style={{ fontSize: 12.5, opacity: 0.85, maxWidth: 420 }}>
              Escanea el código QR/código de barras de un activo para consultar su estado al instante, o captura el código
              manualmente.
            </div>
          </div>
          <Badge text="Modo laboratorio" bg="rgba(255,255,255,0.18)" color="#fff" />
        </div>

        <div style={{ display: 'flex', gap: 10, marginTop: 18, flexWrap: 'wrap', alignItems: 'center' }}>
          <Input
            value={scanCode}
            onChange={setScanCode}
            placeholder="Código QR / ID de activo (ej. QR-A001)"
            style={{ minWidth: 260, background: '#fff', color: '#000000'}}
          />
          <Button variant="gold" onClick={() => runScan(scanCode)}>
            Buscar código
          </Button>
          <Button variant="secondary" onClick={abrirCamara}>
            Escanear con cámara
          </Button>
        </div>

        {scanResult && (
          <div
            style={{
              marginTop: 16,
              background: '#fff',
              borderRadius: 10,
              padding: 16,
              color: 'var(--foreground)',
            }}
          >
            {scanResult === 'not-found' ? (
              <div style={{ color: '#b91c1c', fontSize: 13.5, fontWeight: 600 }}>
                No se encontró ningún activo con el código "{scanCode}".
              </div>
            ) : (
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 12 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
                  <div style={{ background: '#fff', border: '1px solid var(--border)', borderRadius: 8, padding: 6, lineHeight: 0 }}>
                    <QRCodeSVG value={scanResult.qr} size={52} />
                  </div>
                  <div>
                    <div style={{ fontSize: 14, fontWeight: 700 }}>{scanResult.nombre}</div>
                    <div style={{ fontSize: 12, color: 'var(--muted-foreground)' }}>
                      {scanResult.id} · {scanResult.ubicacion || 'Sin ubicación'} · Responsable: {scanResult.responsable || 'Sin asignar'}
                    </div>
                  </div>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  <Badge text={scanResult.status} bg={statusStyle(scanResult.status).bg} color={statusStyle(scanResult.status).color} />
                  <button
                    onClick={() => setQrViewing(scanResult)}
                    style={{ border: 'none', background: 'none', color: 'var(--primary)', fontSize: 12, fontWeight: 600, cursor: 'pointer' }}
                  >
                    Ver código QR
                  </button>
                  <button
                    onClick={() => openEdit(scanResult)}
                    style={{ border: 'none', background: 'none', color: 'var(--primary)', fontSize: 12, fontWeight: 600, cursor: 'pointer' }}
                  >
                    Editar / cambiar estado
                  </button>
                  <button
                    onClick={() => handleDelete(scanResult)}
                    style={{ border: 'none', background: 'none', color: '#b91c1c', fontSize: 12, fontWeight: 600, cursor: 'pointer' }}
                  >
                    Eliminar
                  </button>
                </div>
              </div>
            )}
          </div>
        )}
      </Card>

      <Card>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 16, gap: 10, flexWrap: 'wrap' }}>
          <Input value={query} onChange={setQuery} placeholder="Buscar activo por nombre o folio…" style={{ minWidth: 260 }} />
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center' }}>
            {!!filtered.length && (
              <button
                onClick={toggleSelectAll}
                style={{ border: 'none', background: 'none', color: 'var(--primary)', fontSize: 12, fontWeight: 600, cursor: 'pointer' }}
              >
                {selected.size === filtered.length ? 'Deseleccionar todos' : 'Seleccionar todos'}
              </button>
            )}
            <Button
              variant="secondary"
              small
              disabled={!selected.size || generandoPdf}
              onClick={() => descargarQR(filtered.filter((a) => selected.has(a.id)))}
            >
              {generandoPdf ? 'Generando PDF…' : `Descargar seleccionados (${selected.size})`}
            </Button>
            <Button
              variant="secondary"
              small
              disabled={!filtered.length || generandoPdf}
              onClick={() => descargarQR(filtered)}
            >
              {generandoPdf ? 'Generando PDF…' : 'Descargar todos los QR (PDF)'}
            </Button>
            <Button variant="primary" small onClick={openCreate}>
              + Registrar activo
            </Button>
          </div>
        </div>

        {loading ? (
          <div style={{ padding: 20, fontSize: 13, color: 'var(--muted-foreground)' }}>Cargando inventario…</div>
        ) : loadError ? (
          <div style={{ padding: 20, fontSize: 13, color: '#b91c1c' }}>{loadError}</div>
        ) : (
          <Table headers={[' ', 'Folio', 'Nombre', 'Categoría', 'Ubicación', 'Responsable', 'Valor', 'Status', 'Código QR', '']}>
            {filtered.map((a) => (
              <tr key={a.id} style={{ borderBottom: '1px solid var(--border)' }}>
                <td style={{ padding: '10px 12px' }}>
                  <input type="checkbox" checked={selected.has(a.id)} onChange={() => toggleSelect(a.id)} />
                </td>
                <td style={{ padding: '10px 12px', fontFamily: 'monospace', fontSize: 12 }}>{a.id}</td>
                <td style={{ padding: '10px 12px', fontWeight: 500 }}>{a.nombre}</td>
                <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{a.categoria}</td>
                <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{a.ubicacion || '—'}</td>
                <td style={{ padding: '10px 12px', color: 'var(--muted-foreground)' }}>{a.responsable || '—'}</td>
                <td style={{ padding: '10px 12px' }}>{a.valor || '—'}</td>
                <td style={{ padding: '10px 12px' }}>
                  <Badge text={a.status} bg={statusStyle(a.status).bg} color={statusStyle(a.status).color} />
                </td>
                <td style={{ padding: '10px 12px' }}>
                  <button
                    onClick={() => setQrViewing(a)}
                    title="Ver código QR"
                    style={{ border: '1px solid var(--border)', background: '#fff', borderRadius: 6, padding: 4, lineHeight: 0, cursor: 'pointer' }}
                  >
                    <QRCodeSVG value={a.qr} size={32} />
                  </button>
                </td>
                <td style={{ padding: '10px 12px', whiteSpace: 'nowrap' }}>
                  <button
                    onClick={() => openEdit(a)}
                    style={{ border: 'none', background: 'none', color: 'var(--primary)', fontSize: 12, fontWeight: 600, cursor: 'pointer', marginRight: 10 }}
                  >
                    Editar
                  </button>
                  <button
                    onClick={() => handleDelete(a)}
                    style={{ border: 'none', background: 'none', color: '#b91c1c', fontSize: 12, fontWeight: 600, cursor: 'pointer' }}
                  >
                    Eliminar
                  </button>
                </td>
              </tr>
            ))}
            {!filtered.length && (
              <tr>
                <td colSpan={10} style={{ padding: '18px 12px', textAlign: 'center', color: 'var(--muted-foreground)', fontSize: 13 }}>
                  No hay activos registrados{query ? ' que coincidan con la búsqueda' : ''}.
                </td>
              </tr>
            )}
          </Table>
        )}
      </Card>

      {formOpen && (
        <InventoryFormModal initial={editing} busy={busy} onClose={() => setFormOpen(false)} onSubmit={handleSubmit} />
      )}

      {qrViewing && (
        <Modal title="Código QR del activo" onClose={() => setQrViewing(null)} width={360}>
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 12 }}>
            <div style={{ background: '#fff', border: '1px solid var(--border)', borderRadius: 12, padding: 18 }}>
              <QRCodeSVG value={qrViewing.qr} size={200} />
            </div>
            <div style={{ textAlign: 'center' }}>
              <div style={{ fontWeight: 700, fontSize: 14 }}>{qrViewing.nombre}</div>
              <div style={{ fontSize: 12, color: 'var(--muted-foreground)', marginTop: 2 }}>
                Folio: {qrViewing.id} · Código: {qrViewing.qr}
              </div>
            </div>
            <Button
              variant="primary"
              disabled={generandoPdf}
              onClick={() => descargarQR([qrViewing])}
              style={{ width: '100%' }}
            >
              {generandoPdf ? 'Generando PDF…' : 'Descargar este código QR (PDF)'}
            </Button>
          </div>
        </Modal>
      )}

      {cameraOpen && <CameraScannerModal onClose={() => setCameraOpen(false)} onDecoded={onCameraDecoded} />}

      <Toast message={msg} show={show} />
    </div>
  )
}

function InventoryFormModal({
  initial,
  busy,
  onClose,
  onSubmit,
}: {
  initial: Activo | null
  busy: boolean
  onClose: () => void
  onSubmit: (payload: Record<string, unknown>) => void
}) {
  const [nombre, setNombre] = useState(initial?.nombre ?? '')
  const [categoria, setCategoria] = useState(initial?.categoria ?? '')
  const [ubicacion, setUbicacion] = useState(initial?.ubicacion ?? '')
  const [responsable, setResponsable] = useState(initial?.responsable ?? '')
  const [status, setStatus] = useState<Activo['status']>(initial?.status ?? 'Disponible')
  const [valor, setValor] = useState(initial?.valor ?? '')

  const canSubmit = nombre.trim() !== '' && categoria.trim() !== ''

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!canSubmit || busy) return
    onSubmit({
      nombre: nombre.trim(),
      categoria: categoria.trim(),
      ubicacion: ubicacion.trim() || undefined,
      responsable: responsable.trim() || undefined,
      status,
      valor: valor.trim() || undefined,
    })
  }

  return (
    <Modal title={initial ? 'Editar activo' : 'Registrar activo'} onClose={onClose} width={480}>
      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
        <Field label="Nombre del activo *">
          <Input value={nombre} onChange={setNombre} placeholder="Laptop Dell Inspiron 15" style={{ width: '100%' }} />
        </Field>

        <div className="rg-2" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
          <Field label="Categoría *">
            <Input value={categoria} onChange={setCategoria} placeholder="Cómputo, Redes, Laboratorio…" style={{ width: '100%' }} />
          </Field>
          <Field label="Status">
            <Select value={status} onChange={(v) => setStatus(v as Activo['status'])} options={STATUS_OPTIONS} style={{ width: '100%' }} />
          </Field>
        </div>

        <div className="rg-2" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
          <Field label="Ubicación">
            <Input value={ubicacion ?? ''} onChange={setUbicacion} placeholder="Lab TI A-204" style={{ width: '100%' }} />
          </Field>
          <Field label="Responsable">
            <Input value={responsable ?? ''} onChange={setResponsable} placeholder="Nombre del responsable" style={{ width: '100%' }} />
          </Field>
        </div>

        <Field label="Valor">
          <Input value={valor ?? ''} onChange={setValor} placeholder="$14,500" style={{ width: '100%' }} />
        </Field>

        {!initial && (
          <p style={{ fontSize: 12, color: 'var(--muted-foreground)', margin: 0 }}>
            El folio (INV-{new Date().getFullYear()}-###) y el código QR se generan automáticamente al guardar.
          </p>
        )}

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10, marginTop: 4 }}>
          <Button variant="secondary" onClick={onClose}>
            Cancelar
          </Button>
          <Button variant="primary" type="submit">
            {busy ? 'Guardando…' : initial ? 'Guardar cambios' : 'Registrar activo'}
          </Button>
        </div>
      </form>
    </Modal>
  )
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 12.5, fontWeight: 600, color: 'var(--muted-foreground)' }}>
      {label}
      {children}
    </label>
  )
}

// Escáner con cámara real: usa la cámara del dispositivo (getUserMedia vía html5-qrcode)
// para leer QR/códigos de barras en vivo. Al detectar un código válido, lo entrega
// por onDecoded y se cierra solo; si el usuario cierra manualmente o hay error de
// permisos, se detiene la cámara para no dejarla encendida de fondo.
const SCANNER_ELEMENT_ID = 'inventarios-camera-scanner'

function CameraScannerModal({ onClose, onDecoded }: { onClose: () => void; onDecoded: (text: string) => void }) {
  const [error, setError] = useState('')
  const scannerRef = useRef<Html5Qrcode | null>(null)
  const stoppedRef = useRef(false)

  useEffect(() => {
    stoppedRef.current = false
    const scanner = new Html5Qrcode(SCANNER_ELEMENT_ID, { verbose: false })
    scannerRef.current = scanner

    scanner
      .start(
        { facingMode: 'environment' },
        { fps: 10, qrbox: { width: 240, height: 240 } },
        (decodedText) => {
          if (stoppedRef.current) return
          stoppedRef.current = true
          scanner
            .stop()
            .catch(() => {})
            .finally(() => onDecoded(decodedText))
        },
        () => {
          // callback de "no se detectó nada en este frame" — se llama constantemente
          // mientras escanea, no es un error real, así que se ignora.
        }
      )
      .catch(() => {
        setError('No se pudo acceder a la cámara. Revisa los permisos del navegador e inténtalo de nuevo.')
      })

    return () => {
      stoppedRef.current = true
      const current = scannerRef.current
      if (current && current.getState() === 2 /* SCANNING */) {
        current.stop().catch(() => {})
      }
    }
  }, [])

  return (
    <Modal title="Escanear con cámara" onClose={onClose} width={420}>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
        {error ? (
          <div style={{ fontSize: 13, color: '#b91c1c', textAlign: 'center', padding: '20px 8px' }}>{error}</div>
        ) : (
          <p style={{ fontSize: 12.5, color: 'var(--muted-foreground)', margin: 0, textAlign: 'center' }}>
            Apunta la cámara al código QR o de barras del activo.
          </p>
        )}
        <div
          id={SCANNER_ELEMENT_ID}
          style={{ width: '100%', borderRadius: 12, overflow: 'hidden', background: '#000', minHeight: error ? 0 : 260 }}
        />
        <Button variant="secondary" onClick={onClose} style={{ width: '100%' }}>
          Cancelar
        </Button>
      </div>
    </Modal>
  )
}