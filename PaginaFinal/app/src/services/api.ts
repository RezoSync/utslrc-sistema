// Cliente base para hablar con el backend Express/MySQL.
// Todas las demás capas de servicios (auth, index) pasan por aquí.

const API_URL = (import.meta.env.VITE_API_URL as string | undefined) || 'http://localhost:57913/api'
const TOKEN_KEY = 'utslrc_token'
const USER_KEY = 'utslrc_user'

export function getToken(): string | null {
  return localStorage.getItem(TOKEN_KEY)
}

export function setSession(token: string, user: unknown) {
  localStorage.setItem(TOKEN_KEY, token)
  localStorage.setItem(USER_KEY, JSON.stringify(user))
}

export function clearSession() {
  localStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(USER_KEY)
}

export function getStoredUser<T = unknown>(): T | null {
  const raw = localStorage.getItem(USER_KEY)
  return raw ? (JSON.parse(raw) as T) : null
}

export class ApiError extends Error {
  status: number
  constructor(message: string, status: number) {
    super(message)
    this.status = status
  }
}

interface RequestOptions {
  method?: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE'
  body?: unknown
  auth?: boolean // por defecto true - manda el token si existe
}

export async function apiRequest<T = unknown>(path: string, options: RequestOptions = {}): Promise<T> {
  const { method = 'GET', body, auth = true } = options

  const headers: Record<string, string> = { 'Content-Type': 'application/json' }
  if (auth) {
    const token = getToken()
    if (token) headers['Authorization'] = `Bearer ${token}`
  }

  let res: Response
  try {
    res = await fetch(`${API_URL}${path}`, {
      method,
      headers,
      body: body !== undefined ? JSON.stringify(body) : undefined,
    })
  } catch {
    throw new ApiError('No se pudo conectar con el servidor. Verifica que el backend esté encendido.', 0)
  }

  if (res.status === 204) return undefined as T

  let data: any = null
  try {
    data = await res.json()
  } catch {
    // respuesta sin cuerpo JSON
  }

  if (!res.ok) {
    if (res.status === 401) clearSession()
    throw new ApiError(data?.error || `Error ${res.status}`, res.status)
  }

  return data as T
}

// Para subir archivos (multipart/form-data) — no se serializa a JSON ni se fija
// Content-Type manualmente, el navegador arma el boundary correcto solo.
export async function apiUpload<T = unknown>(path: string, formData: FormData): Promise<T> {
  const headers: Record<string, string> = {}
  const token = getToken()
  if (token) headers['Authorization'] = `Bearer ${token}`

  let res: Response
  try {
    res = await fetch(`${API_URL}${path}`, { method: 'POST', headers, body: formData })
  } catch {
    throw new ApiError('No se pudo conectar con el servidor. Verifica que el backend esté encendido.', 0)
  }

  let data: any = null
  try {
    data = await res.json()
  } catch {
    // respuesta sin cuerpo JSON
  }

  if (!res.ok) {
    if (res.status === 401) clearSession()
    throw new ApiError(data?.error || `Error ${res.status}`, res.status)
  }
  return data as T
}

// Para descargar archivos protegidos por token (el navegador no manda headers
// en un <a href>, así que se trae como blob y se abre/objectURL en el cliente).
export async function apiDownload(path: string): Promise<Blob> {
  const headers: Record<string, string> = {}
  const token = getToken()
  if (token) headers['Authorization'] = `Bearer ${token}`

  let res: Response
  try {
    res = await fetch(`${API_URL}${path}`, { method: 'GET', headers })
  } catch {
    throw new ApiError('No se pudo conectar con el servidor. Verifica que el backend esté encendido.', 0)
  }
  if (!res.ok) {
    if (res.status === 401) clearSession()
    throw new ApiError(`Error ${res.status}`, res.status)
  }
  return res.blob()
}

export const api = {
  get: <T = unknown>(path: string) => apiRequest<T>(path, { method: 'GET' }),
  post: <T = unknown>(path: string, body?: unknown, opts?: Partial<RequestOptions>) =>
    apiRequest<T>(path, { method: 'POST', body, ...opts }),
  put: <T = unknown>(path: string, body?: unknown) => apiRequest<T>(path, { method: 'PUT', body }),
  patch: <T = unknown>(path: string, body?: unknown) => apiRequest<T>(path, { method: 'PATCH', body }),
  delete: <T = unknown>(path: string) => apiRequest<T>(path, { method: 'DELETE' }),
  upload: <T = unknown>(path: string, formData: FormData) => apiUpload<T>(path, formData),
  download: (path: string) => apiDownload(path),
}
