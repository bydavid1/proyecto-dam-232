import 'package:flutter/material.dart';

class SetupScheduleScreen extends StatefulWidget {
  const SetupScheduleScreen({Key? key}) : super(key: key);

  @override
  State<SetupScheduleScreen> createState() => _SetupScheduleScreenState();
}

class _SetupScheduleScreenState extends State<SetupScheduleScreen> {
  // 1. Controladores y variables de estado
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _professorController = TextEditingController();
  String? _selectedDay;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  // Opciones mockeadas para el selector de día
  final List<String> _daysOfWeek = [
    'Lunes', 
    'Martes', 
    'Miércoles', 
    'Jueves', 
    'Viernes', 
    'Sábado'
  ];

  // 2. Funciones para seleccionar hora
  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
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

  // 3. Función para guardar la clase
  void _saveClass() {
    if (_subjectController.text.isEmpty || _selectedDay == null) {
      // Usar un SnackBar en lugar de alert()
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete al menos la Materia y el Día.')),
      );
      return;
    }

    // Aquí iría la lógica de guardar en la base de datos (Firestore o similar)
    print('--- Nueva Clase Registrada ---');
    print('Materia: ${_subjectController.text}');
    print('Profesor: ${_professorController.text}');
    print('Día: $_selectedDay');
    print('Hora Inicio: ${_startTime.format(context)}');
    print('Hora Fin: ${_endTime.format(context)}');
    print('------------------------------');

    // Muestra una confirmación y regresa a la pantalla anterior
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Clase guardada exitosamente!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Crear Nueva Clase",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white), // Color del ícono de regreso
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de Materia
            const Text(
              "MATERIA",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                hintText: "Nombre de la materia (Ej: Cálculo I)",
              ),
            ),
            
            const SizedBox(height: 20),

            // Campo de Profesor
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
                // Hora de Inicio
                Expanded(child: _buildTimeSelector(
                  title: "HORA INICIO", 
                  time: _startTime, 
                  onTap: () => _selectTime(context, true)
                )),
                const SizedBox(width: 20),
                // Hora de Fin
                Expanded(child: _buildTimeSelector(
                  title: "HORA FIN", 
                  time: _endTime, 
                  onTap: () => _selectTime(context, false)
                )),
              ],
            ),
            
            const SizedBox(height: 50),

            // Botón de Guardar
            ElevatedButton(
              onPressed: _saveClass,
              child: const Text("GUARDAR CLASE"),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para el selector de hora
  Widget _buildTimeSelector({
    required String title, 
    required TimeOfDay time, 
    required VoidCallback onTap
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
                Text(
                  time.format(context),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const Icon(Icons.access_time, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}