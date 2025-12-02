import 'package:flutter/material.dart';

class AddSubjectScreen extends StatefulWidget {
  // Opcionalmente, pasaremos la materia para el modo edición
  final Map<String, dynamic>? subjectToEdit; 

  const AddSubjectScreen({Key? key, this.subjectToEdit}) : super(key: key);

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  // Controladores de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();

  // Estado del color seleccionado (Rojo por defecto)
  Color _selectedColor = Colors.redAccent;

  // Función auxiliar para convertir String a Color (útil al cargar datos)
  Color _stringToColor(String colorString) {
    String valueString = colorString.substring(1); // Elimina el '#'
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  // Función auxiliar para convertir Color a String (útil al guardar datos)
  String _colorToString(Color color) {
    return '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}';
  }

  @override
  void initState() {
    super.initState();
    // Si estamos en modo edición, precargamos los datos
    if (widget.subjectToEdit != null) {
      _nameController.text = widget.subjectToEdit!['name'];
      _teacherController.text = widget.subjectToEdit!['teacher'];
      _groupController.text = widget.subjectToEdit!['group'];
      
      // Manejo de color: si es un String (simulando datos de la DB), lo convertimos
      final colorValue = widget.subjectToEdit!['color'];
      if (colorValue is Color) {
        _selectedColor = colorValue;
      } else if (colorValue is String) {
        // Asumiendo formato '#AARRGGBB' de la DB
        _selectedColor = _stringToColor(colorValue);
      } else {
        _selectedColor = Colors.redAccent;
      }
    }
  }

  void _saveSubject() {
    // Lógica para guardar o actualizar la materia
    final subjectData = {
      'name': _nameController.text,
      'teacher': _teacherController.text,
      'group': _groupController.text,
      'time': "10:00 - 12:00", // Valor de ejemplo, esto se manejará mejor con TimePickers
      'color': _colorToString(_selectedColor), // Convertir Color a String para el mapa
    };

    if (widget.subjectToEdit == null) {
      print("GUARDAR NUEVA Materia: $subjectData");
      // Lógica futura de Firestore: addDoc(...)
    } else {
      print("ACTUALIZAR Materia ID: ${widget.subjectToEdit!['id'] ?? 'N/A'}: $subjectData");
      // Lógica futura de Firestore: updateDoc(...)
    }

    // Volver a la pantalla anterior
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teacherController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Título dinámico
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
                  const SizedBox(height: 20),
                  _buildInputField("GRUPO (O SECCIÓN)", "Ej. GT1 o Sección A", _groupController),
                  const SizedBox(height: 30),

                  // Selector de color
                  _buildColorPicker(),
                  const SizedBox(height: 40),

                  // Selector de Horario (Simulado)
                  _buildTimePickerSection(),
                ],
              ),
            ),
            
            // Botón de Guardar
            ElevatedButton(
              onPressed: _saveSubject,
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
              child: Text(isEditing ? "GUARDAR CAMBIOS" : "AGREGAR MATERIA"),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildInputField(String label, String hint, TextEditingController controller) {
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
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    final List<Color> colors = [
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
          style: TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: Colors.grey
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15.0, // Espacio horizontal
          runSpacing: 10.0, // Espacio vertical
          children: colors.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 3.0)
                      : null,
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

  Widget _buildTimePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "HORARIO DE CLASES",
          style: TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: Colors.grey
          ),
        ),
        const SizedBox(height: 8),
        // Fila para el día
        _buildTimeInputRow(
          label: "Día de la semana",
          value: "Lunes", // Simulado
          icon: Icons.calendar_today_outlined,
          onTap: () {
            // Lógica futura para un DayPicker
          },
        ),
        const SizedBox(height: 10),
        // Fila para la hora
        _buildTimeInputRow(
          label: "Hora",
          value: "10:00 AM - 12:00 PM", // Simulado
          icon: Icons.access_time,
          onTap: () {
            // Lógica futura para un TimePicker
          },
        ),
      ],
    );
  }

  Widget _buildTimeInputRow({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
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
                style: const TextStyle(fontSize: 14, color: Color(0xFF0B1E3B), fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}