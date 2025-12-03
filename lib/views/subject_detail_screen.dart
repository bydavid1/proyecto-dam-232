import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_dam232/providers/academic_data_manager.dart';
import '../models/academic_models.dart';
import 'add_subject_screen.dart';

class SubjectDetailScreen extends StatelessWidget {
  final Subject subject;

  const SubjectDetailScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(subject.colorHex.replaceFirst('#', '0xff')));

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
          // Botón de editar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blueAccent,
              child: IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSubjectScreen(subjectToEdit: subject),
                    ),
                  );
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
            // 1. Nombre de la materia
            Text(
              subject.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF0B1E3B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // 2. Bloque de información general
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: color, width: 4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn("Profesor", subject.professor),
                  _buildInfoColumn("Color", subject.colorHex),
                  _buildInfoColumn("ID", subject.id.substring(0, 6) + "..."),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 3. Notas o descripción
            const Text(
              "DESCRIPCIÓN",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Aquí puedes agregar información adicional sobre la materia, horarios o detalles del curso.",
                style: TextStyle(
                  color: Colors.grey,
                  height: 1.5,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 4. Botón eliminar materia
            ElevatedButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline),
              label: const Text("ELIMINAR MATERIA"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------
  // Widgets auxiliares
  // -------------------
  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0B1E3B),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // -------------------
  // Confirmar eliminación
  // -------------------
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Eliminar materia"),
          content: const Text(
            "¿Estás seguro de eliminar esta materia? También se eliminarán sus eventos y horarios asociados.",
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(ctx),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("Eliminar"),
              onPressed: () async {
                final dataManager = Provider.of<AcademicDataManager>(
                  context,
                  listen: false,
                );
                await dataManager.deleteSubject(subject.id);
                Navigator.pop(ctx); // Cierra diálogo
                Navigator.pop(context); // Regresa a la lista
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Materia eliminada correctamente")),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
