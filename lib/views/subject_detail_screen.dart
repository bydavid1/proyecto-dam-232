import 'package:flutter/material.dart';

class SubjectDetailScreen extends StatelessWidget {
  // Recibimos los datos de la materia como parámetro
  final Map<String, dynamic> subject;

  const SubjectDetailScreen({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "DETALLE MATERIA",
          style: TextStyle(
            color: Color(0xFF0B1E3B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          // Botón de editar (Círculo azul con lápiz)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blueAccent,
              child: IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                onPressed: () {
                  // Acción editar
                },
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. TÍTULO MATERIA
            Text(
              subject['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF0B1E3B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // 2. FILA DE INFORMACIÓN (Hora y Grupo)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn("Hora de inicio", subject['time'].toString().split(' - ')[0]), 
                _buildInfoColumn("Hora de Finalización", subject['time'].toString().split(' - ')[1]), 
                _buildInfoColumn("Grupo", subject['group'], isLink: true),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // 3. MAESTRO
            const Text(
              "MAESTRO",
              style: TextStyle(
                color: Colors.grey, 
                fontWeight: FontWeight.bold, 
                fontSize: 10,
                letterSpacing: 0.5
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subject['teacher'],
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            // 4. NOTAS
            const Text(
              "NOTAS",
              style: TextStyle(
                color: Colors.grey, 
                fontWeight: FontWeight.bold, 
                fontSize: 10,
                letterSpacing: 0.5
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB), // Fondo gris claro
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: TextStyle(
                  color: Colors.grey, 
                  height: 1.5, 
                  fontSize: 13,
                  fontStyle: FontStyle.italic
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 5. CALIFICACIONES
            const Text(
              "CALIFICACIONES",
              style: TextStyle(
                color: Color(0xFF0B1E3B), 
                fontWeight: FontWeight.bold, 
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),
            _buildGradeItem("Evaluación 1", "9"),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _buildGradeItem("Evaluación 2", "?"),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para columnas de info
  Widget _buildInfoColumn(String label, String value, {bool isLink = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey, 
            fontSize: 10, 
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: isLink ? Colors.blue : const Color(0xFF0B1E3B),
            fontWeight: FontWeight.bold,
            fontSize: 14,
            decoration: isLink ? TextDecoration.underline : TextDecoration.none,
            decorationColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  // Widget auxiliar para items de nota
  Widget _buildGradeItem(String label, String grade) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: const TextStyle(
              fontWeight: FontWeight.w500, 
              color: Color(0xFF4A5568)
            )
          ),
          Text(
            grade, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16,
              color: grade == "?" ? Colors.grey[300] : const Color(0xFF0B1E3B)
            )
          ),
        ],
      ),
    );
  }
}