export interface ServiceTicket {
  id: string
  folio: string
  solicitante: string
  tipo: string
  descripcion?: string | null
  categoria: 'Trámite escolar' | 'Soporte / Incidencia'
  fecha: string
  status: string
}

export const TICKETS: ServiceTicket[] = []

export function setTickets(list: ServiceTicket[]) {
  TICKETS.length = 0
  TICKETS.push(...list)
}