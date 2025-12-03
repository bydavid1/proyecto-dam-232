import 'package:flutter/material.dart';
import 'package:proyecto_dam232/models/academic_models.dart';
import 'package:proyecto_dam232/utils/color.dart';
import 'add_task_event_screen.dart'; // Para editar el evento

class TaskEventDetailScreen extends StatelessWidget {
  final Event event;
  final Subject? subject;

  const TaskEventDetailScreen({
    super.key, 
    required this.event,
    required this.subject,
  });

  // Simulación de una función para manejar el estado
  void _toggleCompletion(BuildContext context) {
    // Lógica futura para actualizar Firestore
    final newState = !event.isCompleted;
    print("Toggle Completion para Evento ID ${event.id}: Nuevo estado $newState");
    
    // Simular el cierre o actualización de la pantalla
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(newState ? "Evento marcado como completado." : "Evento marcado como pendiente.")),
    );
  }
  
  // Icono dinámico según el tipo
  IconData _getIconForType(String type) {
    switch (type) {
      case 'ENTREGA': return Icons.assignment_turned_in_outlined;
      case 'EXAMEN': return Icons.gavel_outlined;
      case 'TUTORIA': return Icons.people_outline;
      case 'OTRO': return Icons.event_note_outlined;
      default: return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = subject != null ? hexToColor(subject!.colorHex) : Colors.grey;
    final bool isCompleted = event.isCompleted;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          event.type,
          style: const TextStyle(
            color: Color(0xFF0B1E3B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          // Botón de editar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blueAccent,
              child: IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskEventScreen(eventToEdit: event),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TÍTULO DEL EVENTO
                  Row(
                    children: [
                      Icon(_getIconForType(event.type), color: color, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          event.title,
                          style: TextStyle(
                            color: const Color(0xFF0B1E3B),
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                            decorationColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),

                  // DETALLES DE FECHA Y HORA
                  _buildDetailRow(
                    label: "Materia", 
                    value: subject?.name ?? "Materia no asignada", 
                    icon: Icons.school_outlined, 
                    valueColor: color
                  ),
                  _buildDetailRow(
                    label: "Fecha Y Hora", 
                    value: event.dueDate.toString(), 
                    icon: Icons.calendar_today_outlined
                  ),
                  
                  const SizedBox(height: 30),

                  // NOTAS
                  const Text(
                    "NOTAS",
                    style: TextStyle(
                      color: Colors.grey, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 12,
                      letterSpacing: 0.5
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB), 
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.description,
                      style: const TextStyle(
                        color: Colors.grey, 
                        height: 1.5, 
                        fontSize: 13,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                  
                  // Estatus
                  const SizedBox(height: 30),
                  _buildStatusBadge(isCompleted, color),
                ],
              ),
            ),
          ),
          
          // BOTÓN DE ACCIÓN (MARCAR/DESMARCAR)
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: ElevatedButton.icon(
              onPressed: () => _toggleCompletion(context),
              icon: Icon(isCompleted ? Icons.undo_outlined : Icons.check_circle_outline, size: 20),
              label: Text(isCompleted ? "MARCAR COMO PENDIENTE" : "MARCAR COMO COMPLETADO"),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? Colors.redAccent : Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para filas de detalle
  Widget _buildDetailRow({required String label, required String value, required IconData icon, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? const Color(0xFF0B1E3B), 
                    fontWeight: FontWeight.w600, 
                    fontSize: 14
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para el estado
  Widget _buildStatusBadge(bool isCompleted, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.withOpacity(0.1) : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Icons.check_circle_outline : Icons.pending_actions_outlined,
            color: isCompleted ? Colors.green : color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            isCompleted ? "COMPLETADO" : "PENDIENTE",
            style: TextStyle(
              color: isCompleted ? Colors.green : color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}