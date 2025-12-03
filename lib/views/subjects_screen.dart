import 'package:flutter/material.dart';
import 'package:proyecto_dam232/views/add_subject_screen.dart';
import 'package:proyecto_dam232/views/subject_detail_screen.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Datos de prueba basados en tu diseño
    final List<Map<String, dynamic>> subjects = [
      {
        "name": "Desarrollo de aplicaciones móviles",
        "teacher": "Juan Perez Gonzales",
        "time": "10:00 am - 12:00 pm",
        "group": "GT1",
        "color": Colors.redAccent,
      },
      {
        "name": "Testing y Calidad de Software",
        "teacher": "Juan Perez Gonzales",
        "time": "10:00 am - 12:00 pm",
        "group": "GT1",
        "color": Colors.green,
      },
      {
        "name": "Redes",
        "teacher": "Juan Perez Gonzales",
        "time": "10:00 am - 12:00 pm",
        "group": "GT1",
        "color": Colors.orange,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // En pestañas principales, usualmente no hay botón "atrás" automática,
        // pero podemos poner el título centrado como en el diseño.
        title: const Text(
          "MIS MATERIAS",
          style: TextStyle(
            color: Color(0xFF0B1E3B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          // LISTADO DE MATERIAS
          ListView.separated(
            padding: const EdgeInsets.only(top: 10, bottom: 100, left: 20, right: 20),
            itemCount: subjects.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return _buildSubjectItem(context, subject);
            },
          ),
          
          // BOTÓN FLOTANTE "AGREGAR"
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSubjectScreen()));
              },
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
              child: const Text("AGREGAR"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectItem(BuildContext context, Map<String, dynamic> subject) {
    return InkWell(
      onTap: () {
        // Navegar a la pantalla de edición de materia
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectDetailScreen(subject: subject)
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono / Color distintivo (Cuadrado con icono de libro)
            Container(
              width: 40,
              height: 45,
              decoration: BoxDecoration(
                color: subject['color'],
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                   BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              ),
              child: const Icon(Icons.book, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1E3B),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "${subject['time']} • ",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        "Grupo ${subject['group']}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subject['teacher'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            
            // Flecha derecha
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}