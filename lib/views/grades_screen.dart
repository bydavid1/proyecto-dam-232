import 'package:flutter/material.dart';
import 'add_grade_screen.dart'; 

class GradesScreen extends StatelessWidget {
  final Map<String, dynamic> subject;

  const GradesScreen({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulación de datos de calificaciones
    final List<Map<String, dynamic>> grades = [
      {"name": "Laboratorio 1", "percentage": 20, "score": 9.5, "max_score": 10},
      {"name": "Examen Parcial", "percentage": 30, "score": 7.0, "max_score": 10},
      {"name": "Proyecto Final", "percentage": 40, "score": null, "max_score": 10}, // Pendiente
      {"name": "Tareas", "percentage": 10, "score": 10.0, "max_score": 10},
    ];

    // Cálculo del progreso y nota total
    double currentProgress = 0;
    double totalWeightedScore = 0;
    double totalPercentageCompleted = 0;

    for (var grade in grades) {
      if (grade['score'] != null) {
        double score = grade['score'];
        double maxScore = grade['max_score'];
        double percentage = grade['percentage'] / 100;
        
        // Contribución de esta nota a la nota final
        double weightedScore = (score / maxScore) * (percentage * 10); // Asumiendo que la nota máxima es 10
        totalWeightedScore += weightedScore;
        totalPercentageCompleted += grade['percentage'];
      }
      currentProgress += grade['percentage'];
    }

    final color = subject['color'] is Color ? subject['color'] : Colors.redAccent;
    final remainingPercentage = 100 - totalPercentageCompleted;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          subject['name'],
          style: const TextStyle(
            color: Color(0xFF0B1E3B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(top: 24, bottom: 80, left: 20, right: 20),
            children: [
              // 1. TARJETA DE RESUMEN
              _buildSummaryCard(
                totalScore: totalWeightedScore,
                progress: totalPercentageCompleted / 100,
                color: color,
              ),

              const SizedBox(height: 30),

              // 2. TÍTULO DE LISTADO
              const Text(
                "EVALUACIONES",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              // 3. LISTA DE CALIFICACIONES
              ...grades.map((grade) => _buildGradeItem(context, grade, color)).toList(),
              
              if (remainingPercentage > 0)
                _buildRemainingItem(remainingPercentage),
            ],
          ),

          // 4. BOTÓN FLOTANTE "AGREGAR"
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddGradeScreen(subjectName: subject['name'])),
                );
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text("AGREGAR NOTA"),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({required double totalScore, required double progress, required Color color}) {
    // Formatea la nota total a un decimal
    String scoreText = totalScore.toStringAsFixed(1);
    
    // Calcula el color del texto de la nota basado en el valor
    Color scoreColor = totalScore >= 6.0 ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "NOTA PROMEDIO ACTUAL (Base 10)",
            style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                scoreText,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: scoreColor,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}% de la materia evaluado",
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text("Se necesita 6.0 para aprobar", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progress, // Valor entre 0.0 y 1.0
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeItem(BuildContext context, Map<String, dynamic> grade, Color color) {
    final bool hasScore = grade['score'] != null;
    final String scoreText = hasScore ? grade['score'].toStringAsFixed(1) : "?";
    final Color scoreColor = hasScore ? (grade['score']! >= 6.0 ? Colors.green : Colors.red) : Colors.grey;

    return InkWell(
      onTap: () {
        // Navegar a editar nota, pasando el ID de la materia y el objeto nota
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddGradeScreen(
            subjectName: subject['name'],
            gradeToEdit: grade,
          )),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF0B1E3B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${grade['percentage']}% de la nota final",
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  scoreText,
                  style: TextStyle(
                    color: scoreColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRemainingItem(double percentage) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Ponderación Pendiente",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            "${percentage.toStringAsFixed(0)}%",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}