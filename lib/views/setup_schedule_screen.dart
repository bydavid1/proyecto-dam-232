import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_dam232/models/academic_models.dart';
import 'package:proyecto_dam232/providers/academic_data_manager.dart';

class SetupScheduleScreen extends StatefulWidget {
  const SetupScheduleScreen({super.key});

  @override
  State<SetupScheduleScreen> createState() => _SetupScheduleScreenState();
}

class _SetupScheduleScreenState extends State<SetupScheduleScreen> {
  Subject? _selectedSubject;
  final TextEditingController _professorController = TextEditingController();
  String? _selectedDay;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  final List<String> _daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado'
  ];

  // Seleccionar hora
  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // Guardar clase
  Future<void> _saveClass() async {
    if (_selectedSubject == null || _selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione una materia y un día.')),
      );
      return;
    }

    final dataManager = context.read<AcademicDataManager>();

    final scheduleItem = ScheduleItem(
      id: UniqueKey().toString(),
      subjectName: _selectedSubject!.name,
      professorName:
          _professorController.text.isEmpty ? _selectedSubject!.professor : _professorController.text,
      dayOfWeek: _selectedDay!,
      startTime: _startTime.format(context),
      endTime: _endTime.format(context),
    );

    await dataManager.addScheduleItem(scheduleItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Clase agregada exitosamente!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<AcademicDataManager>().subjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Crear Nueva Clase",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de Materia
            const Text(
              "MATERIA",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButtonFormField<Subject>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                value: _selectedSubject,
                hint: const Text('Seleccione una materia'),
                isExpanded: true,
                items: subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject.name),
                  );
                }).toList(),
                onChanged: (Subject? newSubject) {
                  setState(() {
                    _selectedSubject = newSubject;
                    _professorController.text = newSubject?.professor ?? '';
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // Campo de Profesor (opcional)
            const Text(
              "PROFESOR (Opcional)",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _professorController,
              decoration: const InputDecoration(
                hintText: "Nombre del profesor",
              ),
            ),

            const SizedBox(height: 20),

            // Selector de Día
            const Text(
              "DÍA DE LA SEMANA",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                value: _selectedDay,
                hint: const Text('Seleccione el día'),
                isExpanded: true,
                items: _daysOfWeek.map((String day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDay = newValue;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // Selectores de Hora
            Row(
              children: [
                Expanded(
                  child: _buildTimeSelector(
                    title: "HORA INICIO",
                    time: _startTime,
                    onTap: () => _selectTime(context, true),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTimeSelector(
                    title: "HORA FIN",
                    time: _endTime,
                    onTap: () => _selectTime(context, false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: _saveClass,
              child: const Text("GUARDAR CLASE"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector({
    required String title,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time.format(context), style: const TextStyle(fontSize: 16, color: Colors.black)),
                const Icon(Icons.access_time, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
