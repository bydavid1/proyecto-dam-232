import 'package:flutter/material.dart';

class AddGradeScreen extends StatefulWidget {
  final String subjectName;
  final Map<String, dynamic>? gradeToEdit;

  const AddGradeScreen({
    Key? key,
    required this.subjectName,
    this.gradeToEdit,
  }) : super(key: key);

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
    if (widget.gradeToEdit != null) {
      _nameController.text = widget.gradeToEdit!['name'] ?? '';
      _percentageController.text = widget.gradeToEdit!['percentage']?.toString() ?? '0';
      _maxScoreController.text = widget.gradeToEdit!['max_score']?.toString() ?? '10';
      
      final score = widget.gradeToEdit!['score'];
      _scoreController.text = (score != null) ? score.toString() : '';
    }
  }

  void _saveGrade() {
    // Convertir textos a números
    final name = _nameController.text;
    final percentage = int.tryParse(_percentageController.text) ?? 0;
    final maxScore = double.tryParse(_maxScoreController.text) ?? 10.0;
    final score = double.tryParse(_scoreController.text);

    // Crear objeto de datos
    final gradeData = {
      "name": name,
      "percentage": percentage,
      "max_score": maxScore,
      "score": score,
      "subjectId": "subj_123", // ID de la materia (se usaría en la integración real)
    };

    if (widget.gradeToEdit == null) {
      print("AGREGAR NUEVA NOTA a ${widget.subjectName}: $gradeData");
      // Lógica futura de Firestore: addDoc(...)
    } else {
      print("ACTUALIZAR NOTA ID: ${widget.gradeToEdit!['id'] ?? 'N/A'} en ${widget.subjectName}: $gradeData");
      // Lógica futura de Firestore: updateDoc(...)
    }

    Navigator.pop(context);
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
              "Materia: ${widget.subjectName}",
              style: const TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.w600, 
                color: Colors.grey
              ),
            ),
            const Divider(height: 20),
            
            Expanded(
              child: ListView(
                children: [
                  _buildInputField("NOMBRE DE LA EVALUACIÓN", "Ej. Examen Parcial", _nameController, isNumeric: false),
                  const SizedBox(height: 20),
                  _buildInputField("PONDERACIÓN (%)", "Ej. 30 (Valor entre 0 y 100)", _percentageController, isNumeric: true),
                  const SizedBox(height: 20),
                  _buildInputField("NOTA MÁXIMA", "Ej. 10.0", _maxScoreController, isNumeric: true),
                  const SizedBox(height: 30),
                  _buildInputField("NOTA OBTENIDA", "Ej. 8.5 (Dejar vacío si está pendiente)", _scoreController, isNumeric: true),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            
            // Botón de Guardar
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

  // Widget auxiliar para campos de texto
  Widget _buildInputField(String label, String hint, TextEditingController controller, {required bool isNumeric}) {
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
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }
}