import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_dam232/providers/academic_data_manager.dart';
import 'package:proyecto_dam232/utils/color.dart'; 
import 'package:proyecto_dam232/views/schedule_screen.dart';
import 'package:proyecto_dam232/views/add_task_event_screen.dart';
import 'package:proyecto_dam232/views/profile_screen.dart';
import 'package:proyecto_dam232/views/subjects_screen.dart';
import 'package:proyecto_dam232/views/task_event_detail_screen.dart';
import 'package:proyecto_dam232/views/task_screen.dart';
import 'package:proyecto_dam232/models/academic_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _views = [
    const HomeDashboardView(),
    const SubjectsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
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

// ------------------------------------------------------------------
// DASHBOARD VIEW
// ------------------------------------------------------------------

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

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

  Widget _buildActivityItem(
    BuildContext context, {
    required Event event,
    required Subject? subject,
  }) {
    final itemColor = subject != null ? hexToColor(subject.colorHex) : Colors.grey;
    final itemTime =
        'Vence: ${event.dueDate.day.toString().padLeft(2, '0')}/${event.dueDate.month.toString().padLeft(2, '0')} ${event.dueDate.hour.toString().padLeft(2, '0')}:${event.dueDate.minute.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskEventDetailScreen(event: event, subject: subject),
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
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: itemColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              event.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF0B1E3B),
                              ),
                            ),
                          ),
                          Text(
                            event.type.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: itemColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subject?.name.toUpperCase() ?? "SIN MATERIA",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        itemTime,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // ✅ Reemplazar Consumer por context.watch para simplificar
    final dataManager = context.watch<AcademicDataManager>();
    final todayEvents = dataManager.todayActivities;

    return Column(
      children: [
        // Encabezado
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
                  Text("Bienvenido, Usuario", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 4),
                  Text(
                    "test_user",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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

        // Contenido principal
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                children: [
                  _buildShortcutCard(
                    context,
                    icon: Icons.schedule,
                    label: "HORARIO",
                    color: Colors.redAccent,
                    targetScreen: const ScheduleScreen(),
                  ),
                  _buildShortcutCard(
                    context,
                    icon: Icons.event_note,
                    label: "EVENTOS",
                    color: Colors.green,
                    targetScreen: const TasksScreen(),
                  ),
                  _buildShortcutCard(
                    context,
                    icon: Icons.class_,
                    label: "MATERIAS",
                    color: Colors.orange,
                    targetScreen: const SubjectsScreen(),
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

              if (todayEvents.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      "¡Felicidades! No tienes actividades pendientes o clases hoy.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ...todayEvents.map((event) {
                  final subject = dataManager.getSubjectById(event.subjectId);
                  return _buildActivityItem(context, event: event, subject: subject);
                }).toList(),

              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskEventScreen()));
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
