import 'package:flutter/material.dart';
import 'add_task_event_screen.dart'; // Para agregar nuevos eventos
import 'task_event_detail_screen.dart'; // Para ver detalles

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // --- SIMULACIÓN DE DATOS DE TAREAS Y EVENTOS ---
    // Usamos el mismo formato para simplificar la lista
    final List<Map<String, dynamic>> tasksAndEvents = [
      {
        "id": "t_001",
        "type": "TUTORIA",
        "name": "Tutoría de Redes",
        "date": "2024-12-05", // Próxima semana
        "time": "14:00",
        "subject": "Redes",
        "color": Colors.orange,
        "isCompleted": false,
      },
      {
        "id": "t_002",
        "type": "ENTREGA",
        "name": "Entrega de Laboratorio 3",
        "date": "2024-12-08", // Próxima semana
        "time": "23:59",
        "subject": "Desarrollo de Aplicaciones Móviles",
        "color": Colors.redAccent,
        "isCompleted": false,
      },
      {
        "id": "t_003",
        "type": "EXAMEN",
        "name": "Examen Final",
        "date": "2024-12-15", // En dos semanas
        "time": "09:00",
        "subject": "Testing y Calidad de Software",
        "color": Colors.green,
        "isCompleted": false,
      },
      {
        "id": "t_004",
        "type": "ENTREGA",
        "name": "Avance de Tesis",
        "date": "2024-11-20", // Tarea pasada (completada)
        "time": "18:00",
        "subject": "Seminario de Investigación",
        "color": Colors.blueAccent,
        "isCompleted": true,
      },
    ];

    // Ordenar por fecha y luego por estado (incompletas primero)
    tasksAndEvents.sort((a, b) {
      if (a['isCompleted'] != b['isCompleted']) {
        return a['isCompleted'] ? 1 : -1; // Incompletas van antes (false: -1)
      }
      return a['date'].compareTo(b['date']); // Ordenar por fecha
    });

    // Separar por estado
    final List<Map<String, dynamic>> pendingTasks = tasksAndEvents.where((t) => !t['isCompleted']).toList();
    final List<Map<String, dynamic>> completedTasks = tasksAndEvents.where((t) => t['isCompleted']).toList();


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
              // 1. TAREAS PENDIENTES
              const Text(
                "TAREAS PENDIENTES",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
              ),
              const SizedBox(height: 10),
              if (pendingTasks.isEmpty)
                _buildEmptyState("¡Todo al día! No hay pendientes próximos."),
              ...pendingTasks.map((task) => _buildTaskItem(context, task)).toList(),

              const SizedBox(height: 30),

              // 2. TAREAS COMPLETADAS
              if (completedTasks.isNotEmpty) ...[
                const Text(
                  "COMPLETADAS",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
                ),
                const SizedBox(height: 10),
                ...completedTasks.map((task) => _buildTaskItem(context, task)).toList(),
              ]
            ],
          ),

          // 3. BOTÓN FLOTANTE "AGREGAR"
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTaskEventScreen()),
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

  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> task) {
    final Color color = task['color'];
    final bool isCompleted = task['isCompleted'];

    // Convertir fecha de YYYY-MM-DD a un formato amigable (ej. 5 de Diciembre)
    final dateParts = task['date'].toString().split('-');
    final monthNames = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
    final monthIndex = int.parse(dateParts[1]) - 1;
    final day = dateParts[2];
    final dateText = "$day ${monthNames[monthIndex]}";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskEventDetailScreen(event: task)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted ? const Color(0xFFE8F5E9) : Colors.white, // Fondo más claro si está completado
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: isCompleted ? Colors.grey : color, width: 4)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isCompleted ? 0.0 : 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono y Fecha/Hora
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
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task['time'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            
            // Título y Materia
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isCompleted ? Colors.grey : const Color(0xFF0B1E3B),
                      decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task['subject'],
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Tipo de Evento / Checkbox
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task['type'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                if (isCompleted)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Icon(Icons.check_circle, color: Colors.green, size: 20),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}