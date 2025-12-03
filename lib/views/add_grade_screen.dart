import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_dam232/models/academic_models.dart';
import 'package:proyecto_dam232/providers/academic_data_manager.dart';

class AddGradeScreen extends StatefulWidget {
  final Subject subject;
  final Grade? gradeToEdit;

  const AddGradeScreen({
    super.key,
    required this.subject,
    this.gradeToEdit,
  });

  @override
  State<AddGradeScreen> createState() => _AddGradeScreenState();
}

class _AddGradeScreenState extends State<AddGradeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _maxScoreController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Si estamos editando, precargar los datos
    if (widget.gradeToEdit != null) {
      final g = widget.gradeToEdit!;
      _nameController.text = g.name;
      _percentageController.text = g.percentage.toString();
      _maxScoreController.text = g.maxScore.toString();
      _scoreController.text = g.score?.toString() ?? '';
    } else {
      _maxScoreController.text = '10';
    }
  }

  Future<void> _saveGrade() async {
    final name = _nameController.text.trim();
    final percentage = double.tryParse(_percentageController.text) ?? 0;
    final maxScore = double.tryParse(_maxScoreController.text) ?? 10.0;
    final score = _scoreController.text.isEmpty
        ? null
        : double.tryParse(_scoreController.text);

    if (name.isEmpty || percentage <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor completa el nombre y la ponderación."),
        ),
      );
      return;
    }

    final dataManager = context.read<AcademicDataManager>();

    final newGrade = Grade(
      id: widget.gradeToEdit?.id ?? '',
      subjectId: widget.subject.id,
      name: name,
      percentage: percentage,
      score: score,
      maxScore: maxScore,
      createdAt: DateTime.now(),
    );

    try {
      if (widget.gradeToEdit == null) {
        await dataManager.addGrade(newGrade);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nota agregada exitosamente.')),
        );
      } else {
        await dataManager.updateGrade(newGrade);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nota actualizada exitosamente.')),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar nota: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _percentageController.dispose();
    _scoreController.dispose();
    _maxScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.gradeToEdit != null;
    final titleText = isEditing ? "EDITAR NOTA" : "AGREGAR NOTA";

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Materia: ${widget.subject.name}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildInputField(
                    "NOMBRE DE LA EVALUACIÓN",
                    "Ej. Examen Parcial",
                    _nameController,
                    isNumeric: false,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    "PONDERACIÓN (%)",
                    "Ej. 30 (Valor entre 0 y 100)",
                    _percentageController,
                    isNumeric: true,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    "NOTA MÁXIMA",
                    "Ej. 10.0",
                    _maxScoreController,
                    isNumeric: true,
                  ),
                  const SizedBox(height: 30),
                  _buildInputField(
                    "NOTA OBTENIDA",
                    "Ej. 8.5 (Dejar vacío si está pendiente)",
                    _scoreController,
                    isNumeric: true,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _saveGrade,
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
              child: Text(isEditing ? "GUARDAR CAMBIOS" : "AGREGAR NOTA"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller, {
    required bool isNumeric,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
