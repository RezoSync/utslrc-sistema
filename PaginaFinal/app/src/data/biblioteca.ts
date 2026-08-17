// Fuente de datos real de Biblioteca (libros y préstamos), poblada por loadAppData().
export interface Libro {
  id: string
  isbn: string
  titulo: string
  autor: string
  categoria: string
  ejemplares: number
  disponibles: number
  portada?: string
  googleBooksId?: string
}

export interface Prestamo {
  id: string
  bookId: string
  libro: string
  studentId: string
  alumno: string
  fechaPrestamo: string
  fechaLimite: string
  fechaDevolucion: string | null
  status: 'Vigente' | 'Vencido' | 'Devuelto'
}

export const BOOKS: Libro[] = []

export function setBooks(list: Libro[]) {
  BOOKS.length = 0
  BOOKS.push(...list)
}

export const LOANS: Prestamo[] = []

export function setLoans(list: Prestamo[]) {
  LOANS.length = 0
  LOANS.push(...list)
}