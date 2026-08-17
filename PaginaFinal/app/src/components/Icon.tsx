import type { CSSProperties } from 'react'
import {
  LayoutGrid,
  Users,
  GraduationCap,
  UserRound,
  Target,
  BookOpen,
  CheckCircle2,
  CalendarDays,
  FileText,
  Library,
  Package,
  Briefcase,
  LifeBuoy,
  BarChart3,
  Settings2,
  UserPlus,
  Pencil,
  Trash2,
  UserCheck,
  UserX,
  Eye,
  Send,
  Wrench,
  X,
  Inbox,
  Search,
  type LucideIcon,
} from 'lucide-react'

// Adaptador delgado sobre lucide-react: se mantiene la misma API (`name`, `size`, `style`)
// que usaba el set de SVG dibujados a mano, así que ui.tsx / Sidebar no necesitan cambios.
export type IconName =
  | 'grid'
  | 'users'
  | 'student'
  | 'teacher'
  | 'target'
  | 'book'
  | 'check'
  | 'calendar'
  | 'file'
  | 'library'
  | 'box'
  | 'briefcase'
  | 'service'
  | 'chart'
  | 'settings'
  | 'userPlus'
  | 'edit'
  | 'trash'
  | 'userCheck'
  | 'userX'
  | 'eye'
  | 'send'
  | 'wrench'
  | 'close'
  | 'inbox'
  | 'search'

const art: Record<IconName, LucideIcon> = {
  grid: LayoutGrid,
  users: Users,
  student: GraduationCap,
  teacher: UserRound,
  target: Target,
  book: BookOpen,
  check: CheckCircle2,
  calendar: CalendarDays,
  file: FileText,
  library: Library,
  box: Package,
  briefcase: Briefcase,
  service: LifeBuoy,
  chart: BarChart3,
  settings: Settings2,
  userPlus: UserPlus,
  edit: Pencil,
  trash: Trash2,
  userCheck: UserCheck,
  userX: UserX,
  eye: Eye,
  send: Send,
  wrench: Wrench,
  close: X,
  inbox: Inbox,
  search: Search,
}

export function Icon({ name, size = 20, style }: { name: IconName; size?: number; style?: CSSProperties }) {
  const Cmp = art[name]
  return <Cmp size={size} strokeWidth={1.8} style={style} aria-hidden="true" />
}