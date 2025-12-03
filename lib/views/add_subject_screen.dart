import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_dam232/providers/academic_data_manager.dart';
import '../models/academic_models.dart';

class AddSubjectScreen extends StatefulWidget {
  final Subject? subjectToEdit; // Ahora usamos el modelo real

  const AddSubjectScreen({super.key, this.subjectToEdit});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  Color _selectedColor = Colors.redAccent;

  @override
  void initState() {
    super.initState();
    if (widget.subjectToEdit != null) {
      _nameController.text = widget.subjectToEdit!.name;
      _teacherController.text = widget.subjectToEdit!.professor;
      _selectedColor = Color(int.parse(widget.subjectToEdit!.colorHex.replaceFirst('#', '0xff')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}';
  }

  Future<void> _saveSubject() async {
    final dataManager = Provider.of<AcademicDataManager>(context, listen: false);

    if (_nameController.text.trim().isEmpty || _teacherController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, completa todos los campos.")),
      );
      return;
    }

    final subject = Subject(
      id: widget.subjectToEdit?.id ?? '', // Firestore generará ID si es nuevo
      name: _nameController.text.trim(),
      professor: _teacherController.text.trim(),
      colorHex: _colorToHex(_selectedColor),
    );

    try {
      if (widget.subjectToEdit == null) {
        await dataManager.addSubject(subject);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Materia agregada exitosamente.")),
        );
      } else {
        await dataManager.updateSubject(subject);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Materia actualizada exitosamente.")),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subjectToEdit != null;
    final titleText = isEditing ? "EDITAR MATERIA" : "AGREGAR MATERIA";

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildInputField("NOMBRE DE LA MATERIA", "Ej. Desarrollo de Aplicaciones", _nameController),
                  const SizedBox(height: 20),
                  _buildInputField("NOMBRE DEL PROFESOR", "Ej. Juan Pérez González", _teacherController),
                  const SizedBox(height: 30),
                  _buildColorPicker(),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _saveSubject,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B1E3B),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0),
              ),
              child: Text(isEditing ? "GUARDAR CAMBIOS" : "AGREGAR MATERIA"),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------
  // Widgets auxiliares
  // -------------------

  Widget _buildInputField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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

  Widget _buildColorPicker() {
    final colors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.brown,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "COLOR DE ETIQUETA",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15.0,
          runSpacing: 10.0,
          children: colors.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.black, width: 3.0) : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
