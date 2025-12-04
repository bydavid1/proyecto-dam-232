import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_dam232/providers/academic_data_manager.dart';
import '../models/academic_models.dart';

class AddTaskEventScreen extends StatefulWidget {
  final Event? eventToEdit; 

  const AddTaskEventScreen({super.key, this.eventToEdit});

  @override
  State<AddTaskEventScreen> createState() => _AddTaskEventScreenState();
}

class _AddTaskEventScreenState extends State<AddTaskEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _selectedType = 'ENTREGA';
  String? _selectedSubjectId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  void initState() {
    super.initState();
    if (widget.eventToEdit != null) {
      final event = widget.eventToEdit!;
      _nameController.text = event.title;
      _notesController.text = event.description;
      _selectedType = event.type;
      _selectedSubjectId = event.subjectId;
      _selectedDate = event.dueDate;
      _selectedTime = TimeOfDay(
        hour: event.dueDate.hour,
        minute: event.dueDate.minute,
      );
    }
  }

  Future<void> _saveEvent() async {
    final dataManager = Provider.of<AcademicDataManager>(context, listen: false);

    if (_nameController.text.trim().isEmpty || _selectedSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos obligatorios')),
      );
      return;
    }

    final dueDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final event = Event(
      id: widget.eventToEdit?.id ?? '',
      title: _nameController.text.trim(),
      description: _notesController.text.trim(),
      subjectId: _selectedSubjectId!,
      dueDate: dueDate,
      type: _selectedType,
      isCompleted: widget.eventToEdit?.isCompleted ?? false,
    );

    if (widget.eventToEdit == null) {
      await dataManager.addEvent(event);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento agregado correctamente')),
      );
    } else {
      await dataManager.updateEvent(event);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento actualizado correctamente')),
      );
    }

    Navigator.pop(context);
  }

  Future<void> _deleteEvent() async {
    if (widget.eventToEdit == null) return;
    final dataManager = Provider.of<AcademicDataManager>(context, listen: false);

    await dataManager.deleteEvent(widget.eventToEdit!.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evento eliminado')),
    );
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<AcademicDataManager>(context);
    final subjects = dataManager.subjects;

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
        actions: isEditing
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: _deleteEvent,
                )
              ]
            : null,
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

                  _buildDropdownField(
                    "TIPO DE EVENTO",
                    _selectedType,
                    ['ENTREGA', 'EXAMEN', 'TUTORIA', 'OTRO'],
                    (value) => setState(() => _selectedType = value!),
                  ),
                  const SizedBox(height: 20),

                  _buildDropdownField(
                    "MATERIA",
                    _selectedSubjectId,
                    subjects.map((s) => s.name).toList(),
                    (value) {
                      final selected = subjects.firstWhere((s) => s.name == value);
                      setState(() => _selectedSubjectId = selected.id);
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildSimulatedPicker(
                    "FECHA",
                    "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
                    Icons.calendar_today_outlined,
                    _pickDate,
                  ),
                  const SizedBox(height: 10),

                  _buildSimulatedPicker(
                    "HORA",
                    _selectedTime.format(context),
                    Icons.access_time,
                    _pickTime,
                  ),
                  const SizedBox(height: 20),

                  _buildNotesField(),
                  const SizedBox(height: 40),
                ],
              ),
            ),

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

  // --- Widgets auxiliares ---

  Widget _buildInputField(String label, String hint, TextEditingController controller, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${label}${isRequired ? ' *' : ''}",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
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
              value: value != null
                  ? (items.contains(value)
                      ? value
                      : items.isNotEmpty
                          ? items.first
                          : null)
                  : (items.isNotEmpty ? items.first : null),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Color(0xFF0B1E3B), fontSize: 14),
              onChanged: onChanged,
              items: items.map((String item) {
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
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
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
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0B1E3B),
                      fontWeight: FontWeight.w500,
                    ),
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
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
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
            ),
          ),
        ),
      ],
    );
  }
}
