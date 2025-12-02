import 'package:flutter/material.dart';

class AddTaskEventScreen extends StatefulWidget {
  final Map<String, dynamic>? eventToEdit;

  const AddTaskEventScreen({Key? key, this.eventToEdit}) : super(key: key);

  @override
  State<AddTaskEventScreen> createState() => _AddTaskEventScreenState();
}

class _AddTaskEventScreenState extends State<AddTaskEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _selectedType = 'ENTREGA'; // Tipo de evento por defecto
  String _selectedSubject = 'Desarrollo de Aplicaciones Móviles'; // Materia por defecto
  String _selectedDate = '2024-12-10'; // Fecha por defecto (simulada)
  String _selectedTime = '10:00 AM'; // Hora por defecto (simulada)

  // Simulación de materias disponibles
  final List<String> availableSubjects = [
    'Desarrollo de Aplicaciones Móviles',
    'Testing y Calidad de Software',
    'Redes',
    'Seminario de Investigación',
  ];
  
  // Tipos de eventos
  final List<String> eventTypes = ['ENTREGA', 'EXAMEN', 'TUTORIA', 'OTRO'];

  @override
  void initState() {
    super.initState();
    if (widget.eventToEdit != null) {
      _nameController.text = widget.eventToEdit!['name'] ?? '';
      _selectedType = widget.eventToEdit!['type'] ?? 'ENTREGA';
      _selectedSubject = widget.eventToEdit!['subject'] ?? availableSubjects.first;
      // En una implementación real, se parsearían la fecha y hora reales
      _selectedDate = widget.eventToEdit!['date'] ?? _selectedDate;
      _selectedTime = widget.eventToEdit!['time'] ?? _selectedTime;
      _notesController.text = widget.eventToEdit!['notes'] ?? ''; // Asumiendo que existe un campo 'notes'
    }
  }

  void _saveEvent() {
    final eventData = {
      'name': _nameController.text,
      'type': _selectedType,
      'subject': _selectedSubject,
      'date': _selectedDate,
      'time': _selectedTime,
      'notes': _notesController.text,
      'isCompleted': widget.eventToEdit?['isCompleted'] ?? false,
      // Color se obtendría del objeto materia, aquí lo simulamos
      'color': _selectedType == 'ENTREGA' ? Colors.redAccent : Colors.blueAccent, 
    };

    if (widget.eventToEdit == null) {
      print("GUARDAR NUEVO EVENTO: $eventData");
      // Lógica futura de Firestore: addDoc(...)
    } else {
      print("ACTUALIZAR EVENTO ID: ${widget.eventToEdit!['id'] ?? 'N/A'}: $eventData");
      // Lógica futura de Firestore: updateDoc(...)
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.eventToEdit != null;
    final titleText = isEditing ? "EDITAR EVENTO" : "NUEVO EVENTO";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 24, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          titleText,
          style: const TextStyle(
            color: Color(0xFF0B1E3B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: isEditing ? [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () {
              // Lógica futura: deleteDoc()
              print("ELIMINAR EVENTO ID: ${widget.eventToEdit!['id']}");
              Navigator.pop(context);
            },
          )
        ] : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildInputField("NOMBRE DEL EVENTO", "Ej. Entrega del Proyecto X", _nameController, isRequired: true),
                  const SizedBox(height: 20),

                  // Selector de Tipo de Evento
                  _buildDropdownField(
                    "TIPO DE EVENTO", 
                    _selectedType, 
                    eventTypes, 
                    (String? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Selector de Materia
                  _buildDropdownField(
                    "MATERIA", 
                    _selectedSubject, 
                    availableSubjects, 
                    (String? newValue) {
                      setState(() {
                        _selectedSubject = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Selector de Fecha (Simulado)
                  _buildSimulatedPicker("FECHA", _selectedDate, Icons.calendar_today_outlined, () {
                    // Lógica futura: showDatePicker
                    print("Mostrar DatePicker");
                  }),
                  const SizedBox(height: 10),

                  // Selector de Hora (Simulado)
                   _buildSimulatedPicker("HORA", _selectedTime, Icons.access_time, () {
                    // Lógica futura: showTimePicker
                    print("Mostrar TimePicker");
                  }),
                  const SizedBox(height: 20),

                  // Notas Adicionales
                  _buildNotesField(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            
            // Botón de Guardar
            ElevatedButton(
              onPressed: _saveEvent,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(isEditing ? "GUARDAR CAMBIOS" : "GUARDAR EVENTO"),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildInputField(String label, String hint, TextEditingController controller, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${label}${isRequired ? ' *' : ''}",
          style: const TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: Colors.grey
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDropdownField(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: Colors.grey
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 1,
              style: const TextStyle(color: Color(0xFF0B1E3B), fontSize: 14),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimulatedPicker(String label, String value, IconData icon, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: Colors.grey
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF0B1E3B), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF0B1E3B), fontWeight: FontWeight.w500),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "NOTAS ADICIONALES",
          style: TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: Colors.grey
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Agrega recordatorios, requisitos o enlaces.",
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}