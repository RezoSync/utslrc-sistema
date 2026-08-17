// Envoltorio sobre express.Router() que atrapa automáticamente los errores
// (incluyendo promesas rechazadas) de los handlers async y los manda a
// next(err) en vez de dejar que tumben todo el proceso de Node.
//
// Express 4 NO atrapa errores lanzados dentro de funciones async: si una
// ruta hace `await pool.query(...)` y la consulta falla, esa excepción se
// convierte en un unhandledRejection que mata el servidor completo (esto es
// lo que pasaba con /api/classroom/feed cuando faltaba la tabla `announcements`).
// Con este wrapper, cualquier error de cualquier ruta responde 500 en vez de
// tirar el backend entero.
const express = require('express')

function wrapHandler(handler) {
  return function wrapped(req, res, next) {
    try {
      const result = handler(req, res, next)
      if (result && typeof result.catch === 'function') {
        result.catch(next)
      }
    } catch (err) {
      next(err)
    }
  }
}

function wrapArgs(args) {
  return args.map((a) => (typeof a === 'function' ? wrapHandler(a) : a))
}

module.exports = function asyncRouter() {
  const router = express.Router()
  const methods = ['get', 'post', 'put', 'patch', 'delete', 'use']
  for (const method of methods) {
    const original = router[method].bind(router)
    router[method] = (...args) => original(...wrapArgs(args))
  }
  return router
}
