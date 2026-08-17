# Backend - Sistema Escolar UTSLRC (IDGS 8-3)

API REST en Node.js + Express + MySQL (mysql2, sin ORM) para reemplazar la
capa de datos mock del frontend (`src/services/index.ts`, `src/data/*.ts`).

## 1. Instalar dependencias

```bash
cd backend
npm install
```

## 2. Configurar variables de entorno

```bash
cp .env.example .env
```

Edita `.env` con los datos de tu MySQL local (usuario, contraseña, etc.) y
cambia `JWT_SECRET` por algo largo y aleatorio.

## 3. Crear la base de datos y las tablas

```bash
mysql -u root -p < sql/schema.sql
```

## 4. Cargar los datos de ejemplo (alumnos, docentes, materias, etc.)

```bash
mysql -u root -p utslrc_sistema < sql/seed.sql
```

## 5. Crear los usuarios de acceso (login real con JWT + bcrypt)

```bash
npm run seed:users
```

Esto crea 4 usuarios de ejemplo (cámbialos en `scripts/seed-users.js` antes
de usar en producción):

| usuario   | contraseña   | rol             |
|-----------|--------------|-----------------|
| admin     | admin123     | Administrador   |
| control   | control123   | Control Escolar |
| mmolina   | docente123   | Docente         |
| 23304059  | alumno123    | Alumno          |

## 6. Levantar el servidor

```bash
npm run dev
```

La API queda en `http://localhost:57913/api`.

## Autenticación

```
POST /api/auth/login          { username, password } -> { token, user }
GET  /api/auth/me             (requiere Authorization: Bearer <token>)
POST /api/auth/users          Solo Administrador, crea nuevos usuarios
```

Todas las demás rutas requieren el header `Authorization: Bearer <token>`.

## Endpoints principales

| Recurso       | Ruta base           | Notas                                      |
|---------------|----------------------|---------------------------------------------|
| Alumnos       | `/api/students`      | `?grupo=IDGS 8-3&q=texto`                   |
| Grupos        | `/api/groups`        | `/:id/average`, `/:id/attendance`           |
| Docentes      | `/api/teachers`      | incluye `grupos` y `materias`               |
| Materias      | `/api/subjects`      | `?grupo=IDGS 8-3`                           |
| Carreras      | `/api/careers`       |                                              |
| Horarios      | `/api/schedules`     | `?grupo=IDGS 8-3`                           |
| Calificaciones| `/api/grades`        | `/student/:studentId`, calcula `final` solo |
| Asistencia    | `/api/attendance`    | `/student/:studentId` (GET y PUT/upsert)    |
| Servicios     | `/api/services`      | trámites e incidencias (tickets)            |
| Inscripciones | `/api/enrollments`   | `?studentId=AL045`                          |

Permisos de escritura (POST/PUT/DELETE): `Administrador` y `Control Escolar`
en general; `Docente` puede además registrar/editar calificaciones y
asistencia. Los tickets de servicio los puede crear cualquier usuario
autenticado.

## Conectar el frontend

En `src/services/index.ts` reemplaza cada función mock por un `fetch` a
`http://localhost:57913/api/...` con el mismo nombre/firma, mandando el
header `Authorization: Bearer <token>` guardado tras el login. Como las
firmas ya coinciden con las páginas actuales, no hay que tocar las páginas.
