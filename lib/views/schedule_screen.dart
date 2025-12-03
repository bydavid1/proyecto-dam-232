import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_dam232/models/academic_models.dart';
import 'package:proyecto_dam232/providers/academic_data_manager.dart';
import 'package:proyecto_dam232/views/setup_schedule_screen.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataManager = context.watch<AcademicDataManager>();
    final scheduleList = dataManager.schedule;

    // Agrupar por día de la semana
    final Map<String, List<ScheduleItem>> groupedSchedule = {};
    for (var item in scheduleList) {
      groupedSchedule.putIfAbsent(item.dayOfWeek, () => []);
      groupedSchedule[item.dayOfWeek]!.add(item);
    }

    final List<String> weekDays = [
      "Lunes",
      "Martes",
      "Miércoles",
      "Jueves",
      "Viernes",
      "Sábado",
      "Domingo",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "MI HORARIO SEMANAL",
          style: TextStyle(
            color: Color(0xFF0B1E3B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        children: weekDays.map((day) {
          final classes = groupedSchedule[day] ?? [];
          return _buildDaySection(context, day, classes);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SetupScheduleScreen()),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        tooltip: 'Agregar nueva clase',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDaySection(
    BuildContext context,
    String day,
    List<ScheduleItem> classes,
  ) {
    final bool isFreeDay = classes.isEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: isFreeDay ? Colors.grey : const Color(0xFF0B1E3B),
              letterSpacing: 1.5,
            ),
          ),
          const Divider(height: 10, color: Colors.grey),

          if (isFreeDay)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "¡Día libre! 🎉",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
            )
          else
            ...classes.map((c) => _buildClassItem(context, c)).toList(),
        ],
      ),
    );
  }

  Widget _buildClassItem(BuildContext context, ScheduleItem classData) {
    final color = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna de horas
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classData.startTime,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0B1E3B),
                ),
              ),
              Text(
                classData.endTime,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 15),

          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
            margin: const EdgeInsets.only(right: 15),
          ),

          // Columna de información de la clase
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classData.subjectName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF0B1E3B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  classData.professorName,
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
