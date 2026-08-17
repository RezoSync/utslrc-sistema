import { api, setSession, clearSession, getStoredUser, getToken } from './api'
import type { Role } from '../types'

export interface AuthUser {
  id: number
  username: string
  nombre: string
  role: Role
  studentId: string | null
  teacherId: string | null
}

interface LoginResponse {
  token: string
  user: AuthUser
}

export const authService = {
  async login(username: string, password: string): Promise<AuthUser> {
    const data = await api.post<LoginResponse>('/auth/login', { username, password }, { auth: false })
    setSession(data.token, data.user)
    return data.user
  },
  logout() {
    clearSession()
  },
  isAuthenticated(): boolean {
    return !!getToken()
  },
  getCurrentUser(): AuthUser | null {
    return getStoredUser<AuthUser>()
  },
}
