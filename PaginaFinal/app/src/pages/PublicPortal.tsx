import { useState } from 'react'
import { Menu, X } from 'lucide-react'
import { CAREERS } from '../data/academic'
import { TEACHERS } from '../data/teachers'
import logoUtslrc from '../assets/logos/logo-utslrc.png'
import heroImg from '../assets/UT4k.png'
import OfertaImg from '../assets/students.jpg'

// Imágenes de "Vida estudiantil" — coloca cada archivo en src/assets/
// y cambia el nombre por el real de cada foto (deportes, cultura, servicio social, emprendimiento).
import deportesImg from '../assets/deportes.jpg'
import culturaImg from '../assets/Cultura.jpg'
import servicioSocialImg from '../assets/servicio-social.jpg'
import emprendimientoImg from '../assets/emprendimiento.jpg'
import programadorImg from '../assets/programador.jpg'
import campusUtslrc from '../assets/campus-utslrc.png'
import ofertaVirtualImg from '../assets/oferta-virtual.png'
import comunidadUtslrcImg from '../assets/comunidad-utslrc.png'

interface PublicStats {
  totalStudents: number
  totalGroups: number
  promedioGlobal: number
  totalCareers: number
}

interface Props {
  onGoLogin: () => void
  stats: PublicStats
}

const NAV_LINKS = [
  { id: 'institucion', label: 'Institución' },
  { id: 'academica', label: 'Oferta académica' },
  { id: 'vida', label: 'Vida estudiantil' },
  { id: 'docentes', label: 'Docentes' },
  { id: 'vinculacion', label: 'Vinculación' },
  { id: 'contacto', label: 'Contacto' },
]

const VIDA_ESTUDIANTIL = [
  { title: 'Deportes', desc: 'Selecciones representativas y torneos internos.', img: deportesImg },
  { title: 'Cultura', desc: 'Talleres de arte, música y expresión.', img: culturaImg },
  { title: 'Servicio social', desc: 'Vinculación comunitaria.', img: servicioSocialImg },
  { title: 'Emprendimiento', desc: 'Incubadora de proyectos.', img: emprendimientoImg },
]

const scroll = (id: string) => document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })

/**
 * Bloque reservado para fotografía institucional real.
 * Sustituir por <img src="..." alt="..." style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
 * cuando se cuente con el material fotográfico definitivo. Sin bordes redondeados,
 * a propósito, para mantener la estética editorial/minimalista.
 */
function PhotoPlaceholder({
  label,
  ratio = '4 / 3',
  style,
}: {
  label: string
  ratio?: string
  style?: React.CSSProperties
}) {
  return (
    <div
      style={{
        aspectRatio: ratio,
        background: 'linear-gradient(135deg, #eef3f4 0%, #e4ecee 100%)',
        border: '1px solid var(--border)',
        display: 'flex',
        alignItems: 'flex-end',
        padding: 18,
        position: 'relative',
        overflow: 'hidden',
        ...style,
      }}
    >
      <span
        style={{
          fontSize: 11,
          fontWeight: 700,
          letterSpacing: '.05em',
          textTransform: 'uppercase',
          color: 'var(--muted-foreground)',
          background: 'rgba(255,255,255,.9)',
          padding: '6px 12px',
        }}
      >
        {label}
      </span>
    </div>
  )
}

export default function PublicPortal({ onGoLogin, stats }: Props) {
  const promedioGlobal = stats.promedioGlobal.toFixed(1)
  const [menuOpen, setMenuOpen] = useState(false)

  function goToSection(id: string) {
    setMenuOpen(false)
    scroll(id)
  }

  return (
    <div style={{ color: 'var(--foreground)', background: 'var(--background)' }}>
      {/* Nav */}
      <nav
        className="public-nav"
        style={{ minHeight: 82, background: '#fff', borderBottom: '1px solid var(--border)', display: 'flex', alignItems: 'center', gap: 30, padding: '0 5vw', position: 'sticky', top: 0, zIndex: 30 }}
      >
        <img src={logoUtslrc} alt="UTSLRC" style={{ height: 54, objectFit: 'contain', flexShrink: 0 }} />
        <div className="public-nav__links" style={{ display: 'flex', gap: 22, flex: 1, justifyContent: 'flex-end', fontSize: 13.5, fontWeight: 700, color: '#46515c' }}>
          {NAV_LINKS.map((l) => (
            <a key={l.id} onClick={() => scroll(l.id)} style={{ cursor: 'pointer' }}>
              {l.label}
            </a>
          ))}
        </div>
        <button
          onClick={onGoLogin}
          className="public-nav__cta"
          style={{ background: 'var(--primary)', color: '#fff', border: 0, padding: '12px 20px', fontWeight: 800, cursor: 'pointer', flexShrink: 0 }}
        >
          Acceso al sistema
        </button>
        <button
          type="button"
          className="public-nav__hamburger"
          aria-label={menuOpen ? 'Cerrar menú' : 'Abrir menú'}
          onClick={() => setMenuOpen((v) => !v)}
          style={{
            display: 'none',
            width: 40,
            height: 40,
            borderRadius: 9,
            border: '1px solid var(--border)',
            background: 'transparent',
            color: 'var(--foreground)',
            cursor: 'pointer',
            alignItems: 'center',
            justifyContent: 'center',
            flexShrink: 0,
          }}
        >
          {menuOpen ? <X size={20} /> : <Menu size={20} />}
        </button>
      </nav>

      {menuOpen && (
        <div
          className="public-nav__drawer"
          style={{
            display: 'none',
            flexDirection: 'column',
            background: '#fff',
            borderBottom: '1px solid var(--border)',
            position: 'sticky',
            top: 82,
            zIndex: 29,
            boxShadow: '0 12px 24px rgba(15,35,45,.10)',
          }}
        >
          {NAV_LINKS.map((l) => (
            <a
              key={l.id}
              onClick={() => goToSection(l.id)}
              style={{ cursor: 'pointer', padding: '14px 5vw', fontSize: 14, fontWeight: 700, color: '#46515c', borderBottom: '1px solid var(--border)' }}
            >
              {l.label}
            </a>
          ))}
        </div>
      )}

      {/* Hero — imagen grande, tipografía enorme, minimalista */}
      <header id="inicio" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', background: '#fff' }}>
        <div style={{ padding: '8vw 5vw', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
          <span style={{ fontSize: 13, fontWeight: 800, letterSpacing: '.16em', textTransform: 'uppercase', color: 'var(--primary-dark)' }}>
            UTSLRC
          </span>
          <h1 style={{ fontSize: 'clamp(44px,6vw,84px)', fontWeight: 900, lineHeight: 0.98, letterSpacing: '-.02em', margin: '18px 0 0', color: 'var(--navy)' }}>
            Un solo
            <br />
            portal para
            <br />
            <span style={{ color: 'var(--primary)' }}>tu vida</span>
            <br />
            universitaria
          </h1>
          <p style={{ fontSize: 14.5, lineHeight: 1.7, color: 'var(--muted-foreground)', maxWidth: 380, margin: '28px 0 0' }}>
            Información institucional, oferta académica y el sistema escolar de la UTSLRC en un mismo lugar.
          </p>
          <div style={{ display: 'flex', gap: 14, marginTop: 34, flexWrap: 'wrap' }}>
            <button onClick={onGoLogin} style={{ border: 0, padding: '15px 26px', fontWeight: 800, fontSize: 13.5, background: 'var(--navy)', color: '#fff', cursor: 'pointer' }}>
              Entrar al sistema
            </button>
            <button onClick={() => scroll('academica')} style={{ border: '1px solid var(--foreground)', padding: '15px 26px', fontWeight: 800, fontSize: 13.5, background: 'transparent', color: 'var(--foreground)', cursor: 'pointer' }}>
              Ver oferta académica
            </button>
          </div>
        </div>
        {/* Fotografía institucional principal */}
        <img
          src={heroImg}
          alt="Campus UTSLRC"
          style={{ width: '100%', minHeight: 680, objectFit: 'cover', display: 'block' }}
        />
      </header>

      {/* Estadísticas — minimalista, sin tarjetas, solo números enormes */}
      <div style={{ borderTop: '1px solid var(--border)', borderBottom: '1px solid var(--border)', backgroundColor: 'var(--navy)', backgroundImage: `linear-gradient(105deg,rgba(8,83,63,.95),rgba(14,133,91,.83)), url(${comunidadUtslrcImg})`, backgroundSize: 'cover', backgroundPosition: 'center' }}>
        <div style={{ maxWidth: 1280, margin: '0 auto', display: 'grid', gridTemplateColumns: 'repeat(4,1fr)' }}>
          {[
            ['Alumnos activos', String(stats.totalStudents)],
            ['Grupos', String(stats.totalGroups)],
            ['Promedio general', promedioGlobal],
            ['Carreras', String(stats.totalCareers || CAREERS.length)],
          ].map(([label, val], i) => (
            <div key={label} style={{ padding: '44px 28px', borderLeft: i === 0 ? 'none' : '1px solid rgba(255,255,255,.14)' }}>
              <b style={{ display: 'block', fontSize: 'clamp(34px,3.6vw,52px)', fontWeight: 900, color: '#fff', lineHeight: 1 }}>{val}</b>
              <span style={{ fontSize: 12, color: '#a9c2cb', textTransform: 'uppercase', letterSpacing: '.06em', fontWeight: 700 }}>{label}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Institución — una sola imagen grande + texto grande, estilo editorial */}
      <section
        id="institucion"
        style={{
          maxWidth: 1600,
          margin: '0 auto',
          padding: '7vw 5vw',
          display: 'grid',
          gridTemplateColumns: '1fr 1.05fr',
          gap: '5vw',
          alignItems: 'center',
        }}
      >
        <img
          src={programadorImg}
          alt="Campus UTSLRC"
          style={{ width: '100%', minHeight: 680, objectFit: 'cover', display: 'block' }}
        />
        <div>
          <span style={{ fontSize: 15, fontWeight: 800, letterSpacing: '.14em', textTransform: 'uppercase', color: 'var(--primary-dark)' }}>
            La única universidad
          </span>
          <h2 style={{ fontSize: 'clamp(72px,9vw,140px)', fontWeight: 900, letterSpacing: '-.02em', lineHeight: 0.92, margin: '14px 0', color: 'var(--primary)' }}>
            TI
          </h2>
          <h3 style={{ fontSize: 'clamp(30px,3.6vw,46px)', fontWeight: 900, letterSpacing: '-.01em', margin: '0 0 34px', color: 'var(--navy)' }}>
            de la región
          </h3>
          <p style={{ fontSize: 16, lineHeight: 1.8, color: 'var(--muted-foreground)', maxWidth: 540, margin: '0 0 22px' }}>
            El sistema de Universidades Tecnológicas se creó hace más de veinticuatro años en el país, con más de
            100 planteles educativos, siete de ellos en Sonora.
          </p>
          <p style={{ fontSize: 16, lineHeight: 1.8, color: 'var(--muted-foreground)', maxWidth: 540, margin: 0 }}>
            La UTSLRC inició operaciones en septiembre de 2010; desde entonces nuestra meta es ser un plantel de
            excelencia que brinde educación superior de calidad para los estudiantes de la región.
          </p>
        </div>
      </section>

      {/* Misión / Visión / Valores — minimalista, sin tarjetas */}
      <section style={{ borderTop: '1px solid var(--border)', background: '#fff' }}>
        <div style={{ maxWidth: 1400, margin: '0 auto', padding: '5vw', display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: '3vw' }}>
          {[
            ['Misión', 'Formar profesionales competentes y éticos que impulsen el desarrollo tecnológico y económico de la región.'],
            ['Visión', 'Ser una universidad tecnológica de referencia nacional por la calidad de sus programas y su vinculación con la industria.'],
            ['Valores', 'Compromiso, honestidad, trabajo en equipo, innovación y responsabilidad social.'],
          ].map(([t, d]) => (
            <div key={t} style={{ borderTop: '3px solid var(--navy)', paddingTop: 18 }}>
              <h3 style={{ fontSize: 22, fontWeight: 900, margin: '0 0 10px' }}>{t}</h3>
              <p style={{ fontSize: 13, color: 'var(--muted-foreground)', lineHeight: 1.65, margin: 0 }}>{d}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Oferta académica — imagen grande a la izquierda, título enorme a la derecha */}
      <section id="academica" style={{ borderTop: '1px solid var(--border)' }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr' }}>
          <img src={OfertaImg} alt="Estudiantes UTSLRC" style={{ width: '100%', minHeight: 680, objectFit: 'cover', display: 'block' }} />
          <div style={{ backgroundColor: 'var(--navy)', backgroundImage: `linear-gradient(120deg,rgba(8,83,63,.94),rgba(14,133,91,.78)), url(${ofertaVirtualImg})`, backgroundSize: 'cover', backgroundPosition: 'center', color: '#fff', display: 'flex', alignItems: 'center', padding: '5vw' }}>
            <h2 style={{ fontSize: 'clamp(40px,5vw,68px)', fontWeight: 900, letterSpacing: '-.02em', lineHeight: 1, margin: 0 }}>
              Oferta
              <br />
              educativa
            </h2>
          </div>
        </div>
        <div style={{ maxWidth: 1600, margin: '0 auto', padding: '5vw' }}>
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(4, 1fr)',
              gap: 18,
            }}
          >
            {CAREERS.map((c, i) => (
              <div
                key={c.id}
                style={{
                  border: '1px solid var(--border)',
                  padding: '26px 22px',
                  background: '#fff',
                  display: 'flex',
                  flexDirection: 'column',
                  minWidth: 0,
                }}
              >
                <div
                  style={{
                    fontSize: 11,
                    color: 'var(--primary-dark)',
                    fontWeight: 800,
                    textTransform: 'uppercase',
                    letterSpacing: '.06em',
                  }}
                >
                  {String(i + 1).padStart(2, '0')} · {c.nivel}
                </div>
                <h3
                  style={{
                    margin: '16px 0 12px',
                    fontSize: 18,
                    fontWeight: 900,
                    letterSpacing: '-.01em',
                    lineHeight: 1.2,
                  }}
                >
                  {c.nombre}
                </h3>
                <p
                  style={{
                    fontSize: 12.5,
                    color: 'var(--muted-foreground)',
                    lineHeight: 1.6,
                    margin: 0,
                    flex: 1,
                  }}
                >
                  {c.descripcion}
                </p>
                <p
                  style={{
                    fontSize: 10.5,
                    color: 'var(--muted-foreground)',
                    marginTop: 18,
                    paddingTop: 14,
                    borderTop: '1px solid var(--border)',
                    fontWeight: 700,
                    textTransform: 'uppercase',
                    letterSpacing: '.03em',
                  }}
                >
                  {c.duracion} · {c.modalidad}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Vida estudiantil — minimalista, imagen grande + título enorme por bloque */}
      <section id="vida" style={{ borderTop: '1px solid var(--border)' }}>
        <div style={{ padding: '5vw 5vw 0' }}>
          <span style={{ fontSize: 13, fontWeight: 800, letterSpacing: '.14em', textTransform: 'uppercase', color: 'var(--primary-dark)' }}>
            Vida estudiantil
          </span>
          <h2 style={{ fontSize: 'clamp(40px,5vw,64px)', fontWeight: 900, letterSpacing: '-.02em', margin: '10px 0 0', color: 'var(--navy)' }}>
            Más allá del aula
          </h2>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)' }}>
          {VIDA_ESTUDIANTIL.map(({ title, desc, img }) => (
            <div key={title}>
              <img
                src={img}
                alt={title}
                style={{ width: '100%', aspectRatio: '3 / 4', objectFit: 'cover', display: 'block' }}
              />
              <div style={{ padding: '18px 20px 40px' }}>
                <b style={{ display: 'block', fontSize: 17, fontWeight: 900, marginBottom: 6 }}>{title}</b>
                <span style={{ fontSize: 12, color: 'var(--muted-foreground)', lineHeight: 1.5 }}>{desc}</span>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Docentes */}
      <section id="docentes" style={{ borderTop: '1px solid var(--border)', background: '#fff' }}>
        <div style={{ maxWidth: 1400, margin: '0 auto', padding: '5vw' }}>
          <span style={{ fontSize: 13, fontWeight: 800, letterSpacing: '.14em', textTransform: 'uppercase', color: 'var(--primary-dark)' }}>
            Docentes
          </span>
          <h2 style={{ fontSize: 'clamp(40px,5vw,64px)', fontWeight: 900, letterSpacing: '-.02em', margin: '10px 0 40px', color: 'var(--navy)' }}>
            Cuerpo académico
          </h2>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 1, background: 'var(--border)' }}>
            {TEACHERS.slice(0, 6).map((t) => (
              <div key={t.id} style={{ background: '#fff', padding: 26, display: 'flex', gap: 16, alignItems: 'center' }}>
                <div style={{ width: 52, height: 52, background: 'var(--navy)', color: '#fff', display: 'grid', placeItems: 'center', fontWeight: 800, fontSize: 14, flexShrink: 0 }}>
                  {t.nombre.split(' ').map((w) => w[0]).slice(0, 2).join('')}
                </div>
                <div>
                  <h3 style={{ margin: '0 0 3px', fontSize: 14.5, fontWeight: 800 }}>{t.nombre}</h3>
                  <span style={{ color: 'var(--muted-foreground)', fontSize: 12 }}>{t.materias[0]}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Vinculación / Directorio / Transparencia */}
      <section id="vinculacion" style={{ borderTop: '1px solid var(--border)' }}>
        <div style={{ maxWidth: 1400, margin: '0 auto', padding: '5vw', display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: '3vw' }}>
          {[
            ['Vinculación', 'Convenios con empresas del sector TI para estadías, estancias y bolsa de trabajo.'],
            ['Directorio', 'Rectoría, Dirección Académica, Servicios Escolares y Coordinaciones de carrera.'],
            ['Transparencia', 'Normatividad, indicadores institucionales y ejercicio presupuestal público.'],
          ].map(([t, d]) => (
            <div key={t}>
              <h3 style={{ fontSize: 20, fontWeight: 900, margin: '0 0 10px' }}>{t}</h3>
              <p style={{ color: 'var(--muted-foreground)', fontSize: 13, lineHeight: 1.65, margin: 0 }}>{d}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Contacto */}
      <footer id="contacto" style={{ backgroundColor: 'var(--navy)', backgroundImage: `linear-gradient(105deg,rgba(8,79,62,.96),rgba(10,112,79,.90)), url(${campusUtslrc})`, backgroundSize: 'cover', backgroundPosition: 'center', color: '#d7e5e9', padding: '5vw 5vw 40px' }}>
        <div style={{ maxWidth: 1400, margin: 'auto', display: 'grid', gridTemplateColumns: '1.3fr 1fr 1fr 1fr', gap: 44 }}>
          <div>
            <h4 style={{ color: '#fff', fontWeight: 900, marginTop: 0, fontSize: 16 }}>UTSLRC</h4>
            <p style={{ fontSize: 13, lineHeight: 1.7, color: '#b8ccd3' }}>
              Universidad Tecnológica de San Luis Río Colorado. Formando profesionales para el desarrollo tecnológico regional.
            </p>
          </div>
          <div>
            <h4 style={{ color: '#fff', fontWeight: 800, marginTop: 0, fontSize: 14 }}>Contacto</h4>
            <ul style={{ listStyle: 'none', padding: 0, margin: 0, fontSize: 13, lineHeight: 1.9, color: '#b8ccd3' }}>
              <li>San Luis Río Colorado, Sonora</li>
              <li>contacto@utslrc.edu.mx</li>
              <li>(653) 000 0000</li>
            </ul>
          </div>
          <div>
            <h4 style={{ color: '#fff', fontWeight: 800, marginTop: 0, fontSize: 14 }}>Portal</h4>
            <ul style={{ listStyle: 'none', padding: 0, margin: 0, fontSize: 13, lineHeight: 1.9, color: '#b8ccd3' }}>
              {NAV_LINKS.slice(0, 4).map((l) => (
                <li key={l.id} onClick={() => scroll(l.id)} style={{ cursor: 'pointer' }}>
                  {l.label}
                </li>
              ))}
            </ul>
          </div>
          <div>
            <h4 style={{ color: '#fff', fontWeight: 800, marginTop: 0, fontSize: 14 }}>Sistema</h4>
            <ul style={{ listStyle: 'none', padding: 0, margin: 0, fontSize: 13, lineHeight: 1.9, color: '#b8ccd3' }}>
              <li onClick={onGoLogin} style={{ cursor: 'pointer' }}>
                Acceso al sistema
              </li>
              <li>Servicios escolares</li>
              <li>Soporte técnico</li>
            </ul>
          </div>
        </div>
        <div style={{ maxWidth: 1400, margin: '40px auto 0', paddingTop: 20, borderTop: '1px solid rgba(255,255,255,.14)', fontSize: 12, color: '#91a9b2' }}>
          © 2026 Universidad Tecnológica de San Luis Río Colorado. Sistema integral universitario.
        </div>
      </footer>
    </div>
  )
}
