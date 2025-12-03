import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_dam232/providers/academic_data_manager.dart';
import '../models/academic_models.dart';
import 'add_task_event_screen.dart';
import 'task_event_detail_screen.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<AcademicDataManager>(context);
    final List<Event> events = dataManager.events;
    final List<Subject> subjects = dataManager.subjects;

    // Ordenar por estado y fecha
    events.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return a.dueDate.compareTo(b.dueDate);
    });

    final pending = events.where((e) => !e.isCompleted).toList();
    final completed = events.where((e) => e.isCompleted).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "PENDIENTES Y EVENTOS",
          style: TextStyle(
            color: Color(0xFF0B1E3B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(top: 20, bottom: 80, left: 20, right: 20),
            children: [
              const Text(
                "TAREAS PENDIENTES",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2),
              ),
              const SizedBox(height: 10),
              if (pending.isEmpty)
                _buildEmptyState("¡Todo al día! No hay pendientes próximos."),
              ...pending.map((e) => _buildTaskItem(context, e, subjects)).toList(),

              const SizedBox(height: 30),

              if (completed.isNotEmpty) ...[
                const Text(
                  "COMPLETADAS",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.2),
                ),
                const SizedBox(height: 10),
                ...completed.map((e) => _buildTaskItem(context, e, subjects)).toList(),
              ]
            ],
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTaskEventScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text("NUEVO EVENTO O TAREA"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B1E3B),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Event event, List<Subject> subjects) {
    final dataManager = Provider.of<AcademicDataManager>(context, listen: false);
    final subject = subjects.firstWhere(
      (s) => s.id == event.subjectId,
      orElse: () => Subject(
        id: '',
        name: 'Materia no asignada',
        professor: '',
        colorHex: '#B0BEC5',
      ),
    );

    final color = Color(
      int.parse(subject.colorHex.replaceFirst('#', '0xff')),
    );

    final day = event.dueDate.day;
    final monthNames = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
    final dateText = "$day ${monthNames[event.dueDate.month - 1]}";
    final timeText =
        "${event.dueDate.hour.toString().padLeft(2, '0')}:${event.dueDate.minute.toString().padLeft(2, '0')}";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskEventDetailScreen(event: event, subject: subject)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: event.isCompleted ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: event.isCompleted ? Colors.grey : color, width: 4)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(event.isCompleted ? 0.0 : 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    dateText,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeText,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: event.isCompleted ? Colors.grey : const Color(0xFF0B1E3B),
                      decoration:
                          event.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject.name,
                    style: TextStyle(color: color, fontSize: 12),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    event.type.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    event.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: event.isCompleted ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                  onPressed: () async {
                    await dataManager.updateEventCompletion(event.id, !event.isCompleted);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
