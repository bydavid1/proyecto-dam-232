import React, { useState, useEffect } from 'react';
import { 
  Home, Book, User, ChevronLeft, Plus, 
  Calendar, Clock, Users, Edit2, Trash2, 
  CheckCircle, X, LogOut, Lock, ChevronRight 
} from 'lucide-react';

// --- MOCK DATA INICIAL ---
const INITIAL_USER = {
  name: "Byron David Martinez",
  handle: "@bydavid",
  avatar: "https://i.pravatar.cc/150?u=byron",
  password: "123"
};

const INITIAL_SUBJECTS = [
  { 
    id: 1, 
    name: "Desarrollo de aplicaciones móviles", 
    teacher: "Juan Perez Gonzales", 
    startTime: "10:00", 
    endTime: "12:00", 
    group: "GT1",
    color: "bg-red-500",
    notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    grades: [
      { id: 1, name: "Evaluacion 1", score: 9 },
      { id: 2, name: "Evaluacion 2", score: null }
    ]
  },
  { 
    id: 2, 
    name: "Testing y Calidad de Software", 
    teacher: "Maria Rodriguez", 
    startTime: "13:00", 
    endTime: "15:00", 
    group: "GT2",
    color: "bg-green-500",
    notes: "Traer laptop para pruebas.",
    grades: []
  },
  { 
    id: 3, 
    name: "Redes", 
    teacher: "Carlos Lopez", 
    startTime: "08:00", 
    endTime: "10:00", 
    group: "GT1",
    color: "bg-orange-500",
    notes: "",
    grades: []
  }
];

const INITIAL_EVENTS = [
  {
    id: 1,
    subjectId: 1,
    title: "Tutoría",
    type: "class", // class, assignment, exam
    date: "2023-05-06", // YYYY-MM-DD
    startTime: "10:00 a.m.",
    endTime: "12:00 p.m.",
    notes: "Revisión de avances del proyecto final.",
    completed: false,
    attendance: false
  },
  {
    id: 2,
    subjectId: 2,
    title: "Entrega de laboratorio 2",
    type: "assignment",
    date: "2023-05-06",
    startTime: "10:00 a.m.",
    endTime: "12:00 p.m.",
    notes: "Entrega en formato PDF en el portal.",
    completed: false,
    grade: null
  }
];

// --- COMPONENTS ---

const Button = ({ children, onClick, variant = 'primary', className = '' }) => {
  const baseStyle = "w-full py-4 rounded-lg font-bold text-sm transition-colors";
  const variants = {
    primary: "bg-[#0B1E3B] text-white hover:bg-[#162d50]",
    secondary: "bg-gray-200 text-gray-700 hover:bg-gray-300",
    outline: "border border-gray-300 text-gray-700 hover:bg-gray-50",
    danger: "bg-red-500 text-white hover:bg-red-600"
  };
  return (
    <button onClick={onClick} className={`${baseStyle} ${variants[variant]} ${className}`}>
      {children}
    </button>
  );
};

const Input = ({ label, value, onChange, type = "text", placeholder, multiline = false }) => (
  <div className="mb-4">
    <label className="block text-xs font-bold text-gray-500 uppercase mb-2 ml-1">{label}</label>
    {multiline ? (
      <textarea 
        className="w-full bg-gray-100 p-4 rounded-lg text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#0B1E3B] min-h-[100px]"
        value={value}
        onChange={onChange}
        placeholder={placeholder}
      />
    ) : (
      <input 
        type={type}
        className="w-full bg-gray-100 p-4 rounded-lg text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#0B1E3B]"
        value={value}
        onChange={onChange}
        placeholder={placeholder}
      />
    )}
  </div>
);

const Header = ({ title, showBack, onBack, rightAction }) => (
  <div className="flex items-center justify-between p-4 bg-white sticky top-0 z-10">
    <div className="flex items-center">
      {showBack && (
        <button onClick={onBack} className="mr-4 p-2 -ml-2 text-gray-600">
          <ChevronLeft size={24} />
        </button>
      )}
      <h1 className="text-lg font-bold text-[#0B1E3B] uppercase tracking-wide">{title}</h1>
    </div>
    {rightAction}
  </div>
);

const BottomNav = ({ currentTab, onTabChange }) => {
  const tabs = [
    { id: 'HOME', icon: Home, label: 'Inicio' },
    { id: 'SUBJECTS', icon: Book, label: 'Materias' },
    { id: 'PROFILE', icon: User, label: 'Perfil' },
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 flex justify-around py-3 px-2 pb-6 z-20">
      {tabs.map((tab) => {
        const Icon = tab.icon;
        const isActive = currentTab === tab.id;
        return (
          <button 
            key={tab.id} 
            onClick={() => onTabChange(tab.id)}
            className={`flex flex-col items-center justify-center w-full ${isActive ? 'text-[#0B1E3B]' : 'text-gray-400'}`}
          >
            <Icon size={24} strokeWidth={isActive ? 2.5 : 2} />
            <span className="text-[10px] mt-1 font-medium">{tab.label}</span>
          </button>
        );
      })}
    </div>
  );
};

// --- APP COMPONENT ---

export default function PlanificadorApp() {
  const [view, setView] = useState('LOGIN'); // LOGIN, HOME, SUBJECTS, PROFILE, etc.
  const [history, setHistory] = useState([]); // Simple navigation stack
  const [activeTab, setActiveTab] = useState('HOME');
  
  const [user, setUser] = useState(INITIAL_USER);
  const [subjects, setSubjects] = useState(INITIAL_SUBJECTS);
  const [events, setEvents] = useState(INITIAL_EVENTS);
  
  // Selection States
  const [selectedSubject, setSelectedSubject] = useState(null);
  const [selectedEvent, setSelectedEvent] = useState(null);
  
  // Modal States
  const [showGradeModal, setShowGradeModal] = useState(false);
  const [showAttendanceModal, setShowAttendanceModal] = useState(false);
  const [gradeInput, setGradeInput] = useState('');

  // --- NAVIGATION HELPERS ---
  const navigateTo = (newView, params = {}) => {
    setHistory([...history, { view, params: { selectedSubject, selectedEvent } }]);
    setView(newView);
    window.scrollTo(0,0);
  };

  const goBack = () => {
    if (history.length === 0) return;
    const prev = history[history.length - 1];
    setHistory(history.slice(0, -1));
    setView(prev.view);
    // Restore context if needed, though simple back usually suffices
  };

  const handleTabChange = (tab) => {
    setHistory([]); // Clear history when switching main tabs
    setActiveTab(tab);
    setView(tab);
  };

  // --- LOGIC HELPERS ---
  const getSubjectById = (id) => subjects.find(s => s.id === parseInt(id));

  const handleLogin = (e) => {
    e.preventDefault();
    setView('HOME');
  };

  const handleSaveSubject = (newSubject) => {
    if (newSubject.id) {
      setSubjects(subjects.map(s => s.id === newSubject.id ? newSubject : s));
    } else {
      setSubjects([...subjects, { ...newSubject, id: Date.now(), grades: [] }]);
    }
    goBack();
  };

  const handleSaveEvent = (newEvent) => {
    if (newEvent.id) {
      setEvents(events.map(e => e.id === newEvent.id ? newEvent : e));
    } else {
      setEvents([...events, { ...newEvent, id: Date.now() }]);
    }
    goBack();
  };

  const handleDeleteSubject = (id) => {
    setSubjects(subjects.filter(s => s.id !== id));
    setView('SUBJECTS');
    setHistory([]);
  };

  const handleDeleteEvent = (id) => {
    setEvents(events.filter(e => e.id !== id));
    goBack();
  };

  // --- VIEWS ---

  const LoginView = () => (
    <div className="min-h-screen bg-white flex flex-col p-8 justify-center">
      <div className="flex flex-col items-center mb-12">
        <div className="w-24 h-32 bg-[#0B1E3B] rounded-lg flex items-center justify-center mb-6 shadow-xl relative">
          <div className="w-8 h-8 bg-white/20 rounded-full absolute top-4 right-4"></div>
        </div>
        <h1 className="text-xl font-bold text-[#0B1E3B] tracking-widest text-center">PLANIFICADOR ESCOLAR</h1>
      </div>

      <form onSubmit={handleLogin} className="space-y-6">
        <Input label="Usuario" placeholder="Ingrese su usuario" />
        <Input label="Contraseña" type="password" placeholder="Ingrese su contraseña" />
        
        <div className="pt-8">
          <Button onClick={handleLogin}>INICIAR SESION</Button>
        </div>
      </form>
    </div>
  );

  const HomeView = () => {
    const todayEvents = events.filter(e => e.date === "2023-05-06"); // Mocking today as this date

    return (
      <div className="min-h-screen bg-white pb-24">
        <div className="bg-[#0B1E3B] p-6 pt-12 pb-8 rounded-b-3xl shadow-lg">
          <div className="flex justify-between items-center text-white">
            <div>
              <p className="text-sm opacity-80">Bienvenido,</p>
              <h2 className="text-2xl font-bold">{user.name.split(" ")[0]}</h2>
            </div>
            <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center">
              <User size={20} />
            </div>
          </div>
        </div>

        <div className="p-6">
          <h3 className="text-gray-500 font-bold text-xs uppercase mb-4 tracking-wider">Actividades de Hoy</h3>
          
          <div className="space-y-4">
            {todayEvents.map(evt => {
              const sub = getSubjectById(evt.subjectId);
              return (
                <div 
                  key={evt.id} 
                  onClick={() => { setSelectedEvent(evt); navigateTo('EVENT_DETAIL'); }}
                  className="flex bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden cursor-pointer active:scale-95 transition-transform"
                >
                  <div className={`w-2 ${sub?.color || 'bg-gray-400'}`}></div>
                  <div className="p-4 flex-1">
                    <div className="flex justify-between items-start mb-1">
                      <h4 className="font-bold text-[#0B1E3B]">{evt.title}</h4>
                      <span className="text-xs font-bold text-blue-600 bg-blue-50 px-2 py-1 rounded">{sub?.group}</span>
                    </div>
                    <p className="text-xs text-gray-500 uppercase font-bold mb-2">{sub?.name}</p>
                    <div className="flex justify-between text-xs text-gray-400">
                      <span>Inicio: {evt.startTime}</span>
                      <span>Final: {evt.endTime}</span>
                    </div>
                  </div>
                </div>
              );
            })}

            <div 
              onClick={() => { setSelectedEvent(null); navigateTo('EDIT_EVENT'); }}
              className="mt-8 border-2 border-dashed border-gray-300 rounded-xl p-4 flex flex-col items-center justify-center text-gray-400 cursor-pointer hover:bg-gray-50"
            >
              <Plus size={24} className="mb-2" />
              <span className="text-xs font-bold uppercase">Agregar Evento Rápido</span>
            </div>
          </div>
        </div>
      </div>
    );
  };

  const SubjectsView = () => (
    <div className="min-h-screen bg-white pb-24">
      <Header title="Mis Materias" />
      <div className="p-4 space-y-3">
        {subjects.map(sub => (
          <div 
            key={sub.id} 
            onClick={() => { setSelectedSubject(sub); navigateTo('SUBJECT_DETAIL'); }}
            className="flex items-center p-4 bg-white border-b border-gray-100 cursor-pointer hover:bg-gray-50"
          >
            <div className={`w-10 h-12 rounded ${sub.color} shadow-sm mr-4 flex-shrink-0`}></div>
            <div className="flex-1">
              <h3 className="font-bold text-[#0B1E3B] text-sm">{sub.name}</h3>
              <p className="text-xs text-gray-500 mt-1">{sub.startTime} - {sub.endTime} • Grupo {sub.group}</p>
              <p className="text-xs text-gray-400 mt-0.5">{sub.teacher}</p>
            </div>
            <ChevronRight size={20} className="text-gray-300" />
          </div>
        ))}
      </div>
      <div className="px-6 py-4 fixed bottom-20 w-full max-w-md">
        <Button onClick={() => { setSelectedSubject(null); navigateTo('EDIT_SUBJECT'); }}>AGREGAR</Button>
      </div>
    </div>
  );

  const SubjectDetailView = () => {
    if (!selectedSubject) return null;
    return (
      <div className="min-h-screen bg-white pb-24">
        <Header 
          title="Detalle Materia" 
          showBack onBack={goBack} 
          rightAction={
            <button 
              onClick={() => navigateTo('EDIT_SUBJECT')}
              className="bg-blue-600 text-white p-2 rounded-full shadow-md"
            >
              <Edit2 size={16} />
            </button>
          }
        />
        
        <div className="p-6">
          <h2 className="text-xl font-bold text-[#0B1E3B] mb-1 text-center">{selectedSubject.name}</h2>
          
          <div className="flex justify-between items-center my-6 text-sm">
            <div>
              <p className="text-gray-400 text-xs font-bold uppercase">Hora Inicio</p>
              <p className="font-bold text-[#0B1E3B]">{selectedSubject.startTime}</p>
            </div>
            <div>
              <p className="text-gray-400 text-xs font-bold uppercase">Hora Final</p>
              <p className="font-bold text-[#0B1E3B]">{selectedSubject.endTime}</p>
            </div>
            <div>
              <p className="text-gray-400 text-xs font-bold uppercase">Grupo</p>
              <p className="font-bold text-blue-600 underline cursor-pointer">{selectedSubject.group}</p>
            </div>
          </div>

          <div className="mb-6">
            <p className="text-gray-400 text-xs font-bold uppercase mb-1">Maestro</p>
            <p className="text-sm font-medium">{selectedSubject.teacher}</p>
          </div>

          <div className="mb-6">
            <p className="text-gray-400 text-xs font-bold uppercase mb-2">Notas</p>
            <div className="bg-gray-50 p-4 rounded-lg text-xs text-gray-600 leading-relaxed italic border border-gray-100">
              {selectedSubject.notes || "Sin notas adicionales."}
            </div>
          </div>

          <div>
            <p className="text-[#0B1E3B] font-bold text-xs uppercase mb-4 tracking-wider">Calificaciones</p>
            <div className="space-y-2">
              {selectedSubject.grades.length > 0 ? selectedSubject.grades.map(g => (
                <div key={g.id} className="flex justify-between items-center py-3 border-b border-gray-100">
                  <span className="text-sm font-medium text-gray-600">{g.name}</span>
                  <span className={`font-bold ${g.score ? 'text-[#0B1E3B]' : 'text-gray-300'}`}>
                    {g.score !== null ? g.score : '?'}
                  </span>
                </div>
              )) : (
                <p className="text-gray-400 text-xs">No hay calificaciones registradas</p>
              )}
            </div>
          </div>
        </div>
      </div>
    );
  };

  const EventDetailView = () => {
    if (!selectedEvent) return null;
    const sub = getSubjectById(selectedEvent.subjectId);

    return (
      <div className="min-h-screen bg-white pb-6 relative">
        <Header 
          title="Detalle Evento" 
          showBack onBack={goBack}
          rightAction={
            <button 
              onClick={() => navigateTo('EDIT_EVENT')}
              className="bg-blue-600 text-white p-2 rounded-full shadow-md"
            >
              <Edit2 size={16} />
            </button>
          }
        />

        <div className="p-6">
          <h2 className="text-xl font-bold text-[#0B1E3B] mb-2 text-center">{selectedEvent.title}</h2>
          
          <div className="flex justify-between items-center my-6 text-sm px-4">
            <div>
              <p className="text-gray-400 text-xs font-bold uppercase">Fecha</p>
              <p className="font-bold text-[#0B1E3B] border-b-2 border-[#0B1E3B] pb-0.5">
                {new Date(selectedEvent.date).toLocaleDateString('es-ES', { day: 'numeric', month: 'short' })}
              </p>
            </div>
            <div>
              <p className="text-gray-400 text-xs font-bold uppercase">Hora Fin</p>
              <p className="font-bold text-[#0B1E3B] border-b-2 border-[#0B1E3B] pb-0.5">{selectedEvent.endTime}</p>
            </div>
            <div>
              <p className="text-gray-400 text-xs font-bold uppercase">Grupo</p>
              <p className="font-bold text-blue-600 underline">{sub?.group}</p>
            </div>
          </div>

          <div className="mb-6">
            <p className="text-gray-400 text-xs font-bold uppercase mb-1">Materia</p>
            <p className="text-xs uppercase text-gray-600 font-bold tracking-wide">{sub?.name}</p>
          </div>

          <div className="mb-8">
            <p className="text-gray-400 text-xs font-bold uppercase mb-2">Notas</p>
            <p className="text-xs text-gray-500 leading-relaxed">
              {selectedEvent.notes}
            </p>
          </div>

          <div className="mt-auto">
            {selectedEvent.type === 'assignment' && (
              <Button onClick={() => setShowGradeModal(true)}>REGISTRAR NOTA</Button>
            )}
            {selectedEvent.type === 'class' && (
              <Button onClick={() => setShowAttendanceModal(true)}>REGISTRAR ASISTENCIA</Button>
            )}
             {/* Example of "Mark as submitted" based on designs */}
             {selectedEvent.type !== 'assignment' && selectedEvent.type !== 'class' && (
               <Button onClick={() => { /* Toggle Logic */ }}>MARCAR COMO ENTREGADO</Button>
             )}
          </div>
        </div>

        {/* MODALS */}
        {showGradeModal && (
          <div className="absolute inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl p-6 w-full max-w-xs shadow-2xl">
              <h3 className="text-sm font-bold text-gray-400 uppercase mb-4">Evaluación</h3>
              <p className="text-xs font-bold text-gray-500 mb-2">REGISTRAR NOTA</p>
              <input 
                type="number" 
                className="w-full bg-gray-100 p-3 rounded mb-6 text-center text-lg font-bold" 
                placeholder="0.0"
                value={gradeInput}
                onChange={(e) => setGradeInput(e.target.value)}
              />
              <Button onClick={() => setShowGradeModal(false)}>GUARDAR</Button>
            </div>
          </div>
        )}

        {showAttendanceModal && (
          <div className="absolute inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl p-6 w-full max-w-xs shadow-2xl">
               <h3 className="text-sm font-bold text-gray-400 uppercase mb-4">Tutoría</h3>
               <div className="flex items-center justify-between mb-8">
                 <span className="text-[#0B1E3B] font-medium">Registrar asistencia</span>
                 <div className="w-6 h-6 rounded-full border-2 border-gray-300 cursor-pointer hover:bg-green-100 hover:border-green-500"></div>
               </div>
              <Button onClick={() => setShowAttendanceModal(false)}>ACTUALIZAR</Button>
            </div>
          </div>
        )}
      </div>
    );
  };

  const AddEditSubjectView = () => {
    const isEdit = !!selectedSubject;
    const [formData, setFormData] = useState(
      isEdit ? selectedSubject : { name: '', teacher: '', startTime: '', endTime: '', group: '', color: 'bg-blue-500', notes: '' }
    );

    return (
      <div className="min-h-screen bg-white pb-6">
        <Header title={isEdit ? "Editar Materia" : "Agregar Materia"} showBack onBack={goBack} />
        <div className="p-6">
          <Input 
            label="Nombre" 
            placeholder="Ingrese el nombre de la materia"
            value={formData.name}
            onChange={(e) => setFormData({...formData, name: e.target.value})}
          />
          
          <div className="mb-4">
            <label className="block text-xs font-bold text-gray-500 uppercase mb-2 ml-1">Horario</label>
            <div className="flex gap-4">
              <input 
                 type="time" 
                 className="flex-1 bg-gray-100 p-4 rounded-lg text-sm"
                 value={formData.startTime}
                 onChange={(e) => setFormData({...formData, startTime: e.target.value})}
              />
              <input 
                 type="time" 
                 className="flex-1 bg-gray-100 p-4 rounded-lg text-sm"
                 value={formData.endTime}
                 onChange={(e) => setFormData({...formData, endTime: e.target.value})}
              />
            </div>
          </div>

          <Input 
            label="Maestro" 
            placeholder="Ingrese nombre del maestro"
            value={formData.teacher}
            onChange={(e) => setFormData({...formData, teacher: e.target.value})}
          />

          <Input 
            label="Notas" 
            multiline 
            placeholder="Agregue notas adicionales"
            value={formData.notes}
            onChange={(e) => setFormData({...formData, notes: e.target.value})}
          />

          <div className="mt-8 space-y-4">
            {isEdit && (
              <Button variant="secondary" onClick={() => handleDeleteSubject(formData.id)}>ELIMINAR</Button>
            )}
            <Button onClick={() => handleSaveSubject(formData)}>
              {isEdit ? "ACTUALIZAR" : "GUARDAR"}
            </Button>
          </div>
        </div>
      </div>
    );
  };

  const AddEditEventView = () => {
    const isEdit = !!selectedEvent;
    const [formData, setFormData] = useState(
      isEdit ? selectedEvent : { title: '', date: '', startTime: '', subjectId: '', notes: '' }
    );

    return (
      <div className="min-h-screen bg-white pb-6">
        <Header title={isEdit ? "Editar Evento" : "Nuevo Evento"} showBack onBack={goBack} />
        <div className="p-6">
          <Input 
            label="Nombre" 
            placeholder="Ingrese el nombre del evento"
            value={formData.title}
            onChange={(e) => setFormData({...formData, title: e.target.value})}
          />
          
          <Input 
            label="Fecha" 
            type="date"
            value={formData.date}
            onChange={(e) => setFormData({...formData, date: e.target.value})}
          />

          <div className="mb-4">
             <label className="block text-xs font-bold text-gray-500 uppercase mb-2 ml-1">Materia</label>
             <select 
              className="w-full bg-gray-100 p-4 rounded-lg text-gray-800 focus:outline-none appearance-none"
              value={formData.subjectId}
              onChange={(e) => setFormData({...formData, subjectId: parseInt(e.target.value)})}
             >
               <option value="">Seleccione la materia</option>
               {subjects.map(s => <option key={s.id} value={s.id}>{s.name}</option>)}
             </select>
          </div>

          <Input 
            label="Notas" 
            multiline 
            placeholder="Agregue notas adicionales"
            value={formData.notes}
            onChange={(e) => setFormData({...formData, notes: e.target.value})}
          />

          <div className="mt-8 space-y-4">
            {isEdit && (
              <Button variant="secondary" onClick={() => handleDeleteEvent(formData.id)}>ELIMINAR</Button>
            )}
            <Button onClick={() => handleSaveEvent(formData)}>
              {isEdit ? "ACTUALIZAR" : "GUARDAR"}
            </Button>
          </div>
        </div>
      </div>
    );
  };

  const ProfileView = () => (
    <div className="min-h-screen bg-white pb-24">
      <Header title="" />
      <div className="flex flex-col items-center pt-4 pb-12">
        <div className="w-24 h-24 rounded-full bg-blue-100 flex items-center justify-center text-[#0B1E3B] mb-4 relative">
          <User size={48} />
          <div className="absolute bottom-0 right-0 bg-blue-500 text-white rounded-full p-1 border-2 border-white">
             <Edit2 size={12} />
          </div>
        </div>
        <h2 className="text-xl font-bold text-[#0B1E3B]">{user.name}</h2>
        <p className="text-gray-400 text-sm">{user.handle}</p>
      </div>

      <div className="px-6 space-y-1">
        <button 
          onClick={() => navigateTo('CHANGE_PASSWORD')}
          className="w-full flex justify-between items-center py-5 border-t border-gray-100 text-[#0B1E3B] text-sm font-medium hover:bg-gray-50 px-2"
        >
          <span>Cambiar contraseña</span>
          <ChevronRight size={18} className="text-gray-300" />
        </button>
        <button 
          onClick={() => setView('LOGIN')}
          className="w-full flex justify-between items-center py-5 border-t border-gray-100 text-red-500 text-sm font-medium hover:bg-red-50 px-2"
        >
          <span>Cerrar sesión</span>
          <ChevronRight size={18} className="text-gray-300" />
        </button>
      </div>
    </div>
  );

  const ChangePasswordView = () => (
    <div className="min-h-screen bg-white">
      <Header title="Cambiar Clave" showBack onBack={goBack} />
      <div className="p-6">
        <Input label="Contraseña Actual" type="password" placeholder="Ingrese la contraseña actual" />
        <Input label="Contraseña Nueva" type="password" placeholder="Ingrese la contraseña nueva" />
        <Input label="Repite Contraseña Nueva" type="password" placeholder="Repita la contraseña nueva" />
        
        <div className="mt-8">
           <Button onClick={goBack}>GUARDAR</Button>
        </div>
      </div>
    </div>
  );

  // --- RENDERER ---

  const renderView = () => {
    switch(view) {
      case 'LOGIN': return <LoginView />;
      case 'HOME': return <HomeView />;
      case 'SUBJECTS': return <SubjectsView />;
      case 'PROFILE': return <ProfileView />;
      case 'SUBJECT_DETAIL': return <SubjectDetailView />;
      case 'EVENT_DETAIL': return <EventDetailView />;
      case 'EDIT_SUBJECT': return <AddEditSubjectView />;
      case 'EDIT_EVENT': return <AddEditEventView />;
      case 'CHANGE_PASSWORD': return <ChangePasswordView />;
      default: return <HomeView />;
    }
  };

  return (
    <div className="max-w-md mx-auto shadow-2xl overflow-hidden min-h-screen bg-gray-50 relative font-sans text-slate-800">
      {renderView()}
      
      {['HOME', 'SUBJECTS', 'PROFILE'].includes(view) && (
        <BottomNav currentTab={activeTab} onTabChange={handleTabChange} />
      )}
    </div>
  );
}