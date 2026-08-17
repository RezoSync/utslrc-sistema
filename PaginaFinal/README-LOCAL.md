# UTSLRC Sistema — Ejecución local

## 1. Requisitos
- Node.js 18+ y npm
- MySQL o MariaDB (local o vía XAMPP/phpMyAdmin)

## 2. Backend

```bash
cd backend
npm install
cp .env.example .env
```

Edita `.env` con los datos de tu MySQL local y cambia `JWT_SECRET`.

### Base de datos
Tienes dos opciones (usa solo una):

**Opción A — dump completo (recomendada, ya incluye datos):**
```bash
mysql -u root -p < sql/baseDeDatosActual.sql
```

**Opción B — schema + seed por separado:**
```bash
mysql -u root -p < sql/schema.sql
mysql -u root -p utslrc_sistema < sql/seed.sql
```

**Módulo de Inventarios (tabla nueva, ejecutar siempre):**
```bash
mysql -u root -p utslrc_sistema < sql/inventory.sql
```

**Módulo de Plataforma de Trabajos (tablas nuevas, ejecutar siempre):**
```bash
mysql -u root -p utslrc_sistema < sql/classroom.sql
```

Después, crea los usuarios de acceso (login con JWT + bcrypt):
```bash
npm run seed:users
```

### Iniciar backend
```bash
npm run dev
```
Queda disponible en **http://localhost:57913/api**.

## 3. Frontend

```bash
cd app
npm install
cp .env.example .env
```

`VITE_API_URL` ya apunta a `http://localhost:57913/api` por defecto.

### Iniciar frontend
```bash
npm run dev
```
Queda disponible en **http://localhost:5173**.

## 4. Acceso al sistema
Abre `http://localhost:5173` en el navegador. Verás el portal público; usa el botón de acceso para ir al login.

### Usuarios demo (creados por `npm run seed:users`)
| usuario   | contraseña   | rol             |
|-----------|--------------|-----------------|
| admin     | admin123     | Administrador   |
| control   | control123   | Control Escolar |
| mmolina   | docente123   | Docente         |
| 23304059  | alumno123    | Alumno          |

## Notas
- El `.env` real del backend no se incluye en este ZIP (contiene secretos). Usa `.env.example` como base.
- **Importante:** ejecuta `sql/inventory.sql` y `sql/classroom.sql` aunque ya tengas la base de datos importada — crean tablas nuevas (`inventory_items`, y `announcements`/`assignments`/`submissions`) que el código ya usa pero que faltaban en `baseDeDatosActual.sql`. Sin `classroom.sql`, el backend se caía por completo (`Error: Table 'utslrc_sistema.announcements' doesn't exist`) al abrir Plataforma de Trabajos.
- **Materias y profesores de IDGS 8-3 corregidos:** tanto `baseDeDatosActual.sql` como `seed.sql` ya traen directamente los datos reales del horario oficial (FAS-PA-06, cuatrimestre Mayo-Agosto 2026-2) — no hace falta correr ningún script aparte, solo reimporta el archivo que uses (Opción A o B de arriba). Profesores y materias reales de IDGS 8-3: Seguridad en el Desarrollo de Aplicaciones (Ramon Eduardo Mercado Carreon, Lab. Desarrollo de Software), Ingles VII (Norma Beatriz Flores Nuñez, UD1-A6), Administracion de Base de Datos (Julia Elizabeth Garcia Herrera, UD1-Móvil), Planeacion y Organizacion del Trabajo (Eutilia Guadalupe Olivares Velazquez, UD1-A6), Matematicas para Ingenieria II (Jordy Zaid Quintero Diaz, UD1-A6) y Desarrollo Web Profesional (Aurelio Arturo Flores Quitarte, Lab. Redes Cisco). El horario completo Lu-Vi de 17:00 a 22:00 también quedó cargado tal cual la imagen. **Nota:** esto solo cubre IDGS 8-3 — si tienes el horario real de IDGS 8-1 y 8-2, mándalos y actualizo esos grupos igual.
- Además, corregí el bug de fondo que causaba que **todo el backend se cayera** ante cualquier error de base de datos (no solo el de announcements): las rutas Express no atrapaban errores async, así que cualquier consulta fallida tumbaba el proceso completo de Node. Ahora todas las rutas usan un wrapper (`src/utils/asyncRouter.js`) que atrapa esos errores y responde con un 500 normal en vez de crashear.
- El rol **Administrador** ahora solo ve datos de la carrera IDGS (grupos, alumnos, docentes, materias, horarios e inscripciones); Control Escolar sigue viendo todas las carreras (IDGS, MECA, GEMP, TIC).
- **Materias** ahora muestra el botón "+ Nueva materia" funcional, ligado a los grupos y docentes reales de la base de datos.
- **Inventarios** ahora tiene alta, edición y baja de activos reales (antes esos botones no hacían nada), y el escáner busca contra la base de datos en vez de datos fijos.

