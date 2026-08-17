# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Administradores, personal de Control Escolar, docentes y alumnos de la Universidad Tecnológica de San Luis Río Colorado. Cada rol entra al sistema para consultar y resolver prioridades académicas desde una vista adaptada a sus permisos.

## Product Purpose

El Sistema Integral Universitario UTSLRC centraliza la operación académica: alumnos, grupos, docentes, asistencia, calificaciones, horarios, servicios, inventario y plataforma de trabajos.

## Operating Context

Se usa durante la operación diaria del ciclo escolar. La información debe poder escanearse rápidamente para identificar pendientes, avance académico y acciones por atender.

## Capabilities and Constraints

Aplicación React/Vite existente con autenticación y cuatro roles: Administrador, Control Escolar, Docente y Alumno. El rediseño se limita al dashboard y debe mantener los datos y rutas funcionales existentes. El control de versiones debe ser visible y accionable para el usuario final.

## Brand Commitments

Mantener la identidad UTSLRC y el lenguaje institucional en español.

## Evidence on Hand

Datos académicos y de usuarios demostrativos en `app/src/data/`; flujos de trabajos y anuncios en la plataforma de classroom. No se deben presentar indicadores nuevos como datos reales si no existen en la aplicación.

## Product Principles

- Mostrar primero las decisiones y pendientes relevantes para el rol.
- Mantener datos académicos verificables y acciones directas.
- Reducir el ruido visual sin ocultar contexto operativo.
- Hacer visible la versión de la información que el usuario está consultando.
