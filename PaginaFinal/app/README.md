# Portal UTSLRC — Sistema Integral Universitario

React + TypeScript + Vite. Identidad visual turquesa/azul institucional (proj v2).

## Correr
npm install
npm run dev

## Build
npm run build

## Usuarios demo (sin contraseña real)
Administrador · Control Escolar · Docente · Alumno

## Flujo
Portal público → Acceso al sistema → Login (elige rol) → Dashboard →
Grupos → IDGS 8-1/8-2/8-3 → Alumnos → Perfil → Calificaciones → Asistencia

## Datos reales
65 alumnos reales (IDGS 8-1: 25, 8-2: 19, 8-3: 21) desde los Excel proporcionados,
en src/data/students.ts. Resto de módulos con datos demo centralizados en src/data/
y expuestos vía src/services/.

## Assets
Logos institucionales en src/assets/logos/ (ya integrados en Sidebar, Login y Portal).
