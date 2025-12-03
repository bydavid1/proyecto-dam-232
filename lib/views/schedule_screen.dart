import 'package:flutter/material.dart';
import 'package:proyecto_dam232/views/setup_schedule_screen.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> scheduleData = [
      {
        "day": "LUNES",
        "time": "10:00 - 12:00",
        "subject": "Desarrollo de Aplicaciones Móviles",
        "color": Colors.redAccent,
      },
      {
        "day": "LUNES",
        "time": "13:00 - 15:00",
        "subject": "Testing y Calidad de Software",
        "color": Colors.green,
      },
      {
        "day": "MARTES",
        "time": "08:00 - 10:00",
        "subject": "Redes",
        "color": Colors.orange,
      },
      {
        "day": "MIERCOLES",
        "time": "10:00 - 12:00",
        "subject": "Desarrollo de Aplicaciones Móviles",
        "color": Colors.redAccent,
      },
      {
        "day": "JUEVES",
        "time": "13:00 - 15:00",
        "subject": "Testing y Calidad de Software",
        "color": Colors.green,
      },
      {
        "day": "VIERNES",
        "time": "08:00 - 10:00",
        "subject": "Redes",
        "color": Colors.orange,
      },
    ];

    // Agrupamos los datos por día
    final Map<String, List<Map<String, dynamic>>> groupedSchedule = {};
    for (var item in scheduleData) {
      if (!groupedSchedule.containsKey(item["day"])) {
        groupedSchedule[item["day"]] = [];
      }
      groupedSchedule[item["day"]]!.add(item);
    }

    // Lista ordenada de días
    final List<String> weekDays = [
      "LUNES",
      "MARTES",
      "MIERCOLES",
      "JUEVES",
      "VIERNES",
      "SABADO",
      "DOMINGO",
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
        onPressed: () => _navigateToCreationForm(context),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.settings),
        tooltip: 'Agregar nueva clase',
      ),
    );
  }

  void _navigateToCreationForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SetupScheduleScreen(),
      ), // Navega al formulario
    );
  }

  Widget _buildDaySection(
    BuildContext context,
    String day,
    List<Map<String, dynamic>> classes,
  ) {
    // Si no hay clases, mostramos un indicador de día libre
    bool isFreeDay = classes.isEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del Día
          Text(
            day,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: isFreeDay ? Colors.grey : const Color(0xFF0B1E3B),
              letterSpacing: 1.5,
            ),
          ),
          const Divider(height: 10, color: Colors.grey),

          // Contenido del Día
          if (isFreeDay)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "¡Día Libre! 🎉",
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

  Widget _buildClassItem(BuildContext context, Map<String, dynamic> classData) {
    Color color = classData['color'] is Color
        ? classData['color']
        : Colors.blueAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 6)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna de tiempo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classData['time'].toString().split(' - ')[0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0B1E3B),
                ),
              ),
              Text(
                classData['time'].toString().split(' - ')[1],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 15),
          // Separador visual
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
            margin: const EdgeInsets.only(right: 15),
          ),
          // Columna de información de la materia
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classData['subject'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF0B1E3B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Salón: A101 (Simulado)",
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
