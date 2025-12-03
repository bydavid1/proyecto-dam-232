import 'package:flutter/material.dart';
// Asumiendo que ScheduleScreen se encuentra en la misma carpeta de vistas
import 'package:proyecto_dam232/views/schedule_screen.dart';
import 'package:proyecto_dam232/views/add_task_event_screen.dart';
import 'package:proyecto_dam232/views/profile_screen.dart';
import 'package:proyecto_dam232/views/subjects_screen.dart';
import 'package:proyecto_dam232/views/task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lista de vistas para cada pestaña
  final List<Widget> _views = [
    const HomeDashboardView(),
    const SubjectsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Fondo gris muy suave
      body: _views[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF0B1E3B),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Materias',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET DEL DASHBOARD (INICIO) ---
class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({Key? key}) : super(key: key);

  // Nuevo widget auxiliar para construir cada tarjeta de atajo
  Widget _buildShortcutCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Widget targetScreen,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos Theme.of(context).primaryColor para que los colores sean consistentes
    final primaryColor = Theme.of(context).primaryColor; // 0xFF0B1E3B

    return Column(
      children: [
        // 1. ENCABEZADO AZUL CURVO
        Container(
          padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bienvenido, Usuario",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Byron David", // Nombre mockeado
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 20,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              )
            ],
          ),
        ),

        // 2. CONTENIDO PRINCIPAL
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // --- ATAJOS RÁPIDOS (NUEVA SECCIÓN) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShortcutCard(
                    context,
                    icon: Icons.schedule,
                    label: "HORARIO",
                    color: Colors.redAccent,
                    targetScreen: const ScheduleScreen(), // Navega a la vista semanal
                  ),
                  _buildShortcutCard(
                    context,
                    icon: Icons.event_note,
                    label: "EVENTOS",
                    color: Colors.green,
                    targetScreen: const TasksScreen(), // Usamos la pantalla de agregar como placeholder de eventos
                  ),
                  _buildShortcutCard(
                    context,
                    icon: Icons.class_,
                    label: "MATERIAS",
                    color: Colors.orange,
                    targetScreen: const SubjectsScreen(), // Navega a la vista de Materias
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              const Text(
                "ACTIVIDADES DE HOY",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // ITEMS DE EJEMPLO (Mock Data)
              _buildActivityItem(
                context,
                title: "TUTORIA",
                subject: "Desarrollo de aplicaciones móviles",
                time: "10:00 a.m. - 12:00 p.m.",
                group: "GT1",
                color: Colors.green,
              ),
              _buildActivityItem(
                context,
                title: "TUTORIA",
                subject: "Testing y Calidad de Software",
                time: "10:00 a.m. - 12:00 p.m.",
                group: "GT1",
                color: Colors.pinkAccent,
              ),
              _buildActivityItem(
                context,
                title: "Entrega de laboratorio 2",
                subject: "Redes",
                time: "10:00 a.m. - 12:00 p.m.",
                group: "GT1",
                color: Colors.orange,
              ),

              const SizedBox(height: 20),
              
              // BOTÓN DE AGREGAR RÁPIDO
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTaskEventScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "AGREGAR",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required String title,
    required String subject,
    required String time,
    required String group,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => TaskDetailScreen(
              title: title,
              subject: subject,
              time: time,
              group: group,
              color: color,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Tira de color lateral
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              // Contenido de la tarjeta
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF0B1E3B),
                            ),
                          ),
                          Text(
                            group,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subject.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// New: task detail screen
class TaskDetailScreen extends StatelessWidget {
  final String title;
  final String subject;
  final String time;
  final String group;
  final Color color;

  const TaskDetailScreen({
    Key? key,
    required this.title,
    required this.subject,
    required this.time,
    required this.group,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de actividad'),
        backgroundColor: const Color(0xFF0B1E3B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 6,
              width: 80,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subject, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(time, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.group, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(group, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B1E3B)),
              onPressed: () => Navigator.pop(context),
              child: const Text('VOLVER'),
            ),
          ],
        ),
      ),
    );
  }
}