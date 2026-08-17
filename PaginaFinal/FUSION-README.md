# Fusión utsistema + utslrc-sistema-classroom

Este proyecto combina los dos avances en un solo sistema, sin perder funcionalidad.
La fusión se hizo con un merge real de git (3 vías) usando el commit inicial común
de ambos proyectos como base, así que cada archivo se resolvió comparando
explícitamente ambas versiones — no es un "pegue" a ciegas.

## Qué se tomó de cada lado

**De `utsistema.zip` (sin cambios, porque `classroom` no los tocó):**
- Horarios.tsx, Reportes.tsx, Grupos.tsx, Biblioteca.tsx, Inventarios.tsx,
  Carreras.tsx, Materias.tsx, Configuracion.tsx
- Rutas backend: attendance, careers, enrollments, grades, groups, public, subjects

**De `utslrc-sistema-classroom.zip` (alta/baja de alumnos y profesores, classroom):**
- ControlAlumnado.tsx, Docentes.tsx, Dashboard.tsx, MiEspacio.tsx,
  PlataformaTrabajos.tsx, Servicios.tsx, Perfil.tsx (nueva)
- Rutas backend: students, teachers, services (con auto-generación de ID y
  seguridad por rol), classroom.js (nueva: anuncios, trabajos, entregas)
- Icon.tsx migrado a `lucide-react`, TopBar con menú de perfil/cerrar sesión,
  tokens de diseño y accesibilidad en index.css

**Combinados a mano (ambos lados tenían avances reales sobre el mismo archivo):**
- **Asistencia.tsx, Calificaciones.tsx, Kardex.tsx**: la base es la versión de
  `sistema` (que pediste mantener), con la personalización por rol que agregó
  `classroom` (un Alumno ve solo su propia info).
- **Inscripciones.tsx**: se combinaron las dos vistas — el dashboard de
  distribución por carrera/cuatrimestre de `classroom` arriba, y la tabla
  funcional de inscripción por materia/grupo de `sistema` abajo.
- **schema.sql**: el de `sistema` + las tablas nuevas de `classroom`
  (`announcements`, `assignments`, `submissions`).
- **App.tsx / nav.ts / types.ts / ui.tsx / services/api.ts / services/index.ts**:
  se usó la versión de `classroom` (que ya integraba lo de `sistema` + el
  soporte de rol/estudiante/docente que necesitan las páginas), verificando
  que no faltara nada de lo que tenía `sistema`.

## Verificación

- `npx tsc --noEmit` → sin errores.
- `npm run build` (vite) → compila correctamente.
- Todas las rutas del backend pasaron `node --check` (sin errores de sintaxis).

## Pendiente de tu parte

- Correr `npm install` en `app/` y `backend/` (los `node_modules` no se incluyen).
- Si tu base de datos ya tiene información cargada, usa
  `backend/sql/migration_classroom.sql` en vez de volver a correr `schema.sql`
  (ese sí borra y recrea todas las tablas).
- Revisar `backend/.env` (incluye el `JWT_SECRET` que ya traían tus proyectos).
