import 'package:cloud_firestore/cloud_firestore.dart';


class Subject {
  final String id;
  final String name;
  final String professor;
  final String colorHex; // Para el color de la tarjeta

  Subject({
    required this.id,
    required this.name,
    required this.professor,
    required this.colorHex,
  });

  factory Subject.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Subject(
      id: doc.id,
      name: data['name'] ?? 'Materia sin nombre',
      professor: data['professor'] ?? 'Profesor no asignado',
      colorHex: data['colorHex'] ?? '#0B1E3B', // Color por defecto
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'professor': professor,
      'colorHex': colorHex,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}


class Event {
  final String id;
  final String title;
  final String description;
  final String subjectId;
  final DateTime dueDate;
  final String type; // e.g., 'Tarea', 'Examen', 'Clase'
  final bool isCompleted;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.dueDate,
    required this.type,
    this.isCompleted = false,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? 'Evento sin título',
      description: data['description'] ?? '',
      subjectId: data['subjectId'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      type: data['type'] ?? 'General',
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'subjectId': subjectId,
      'dueDate': dueDate,
      'type': type,
      'isCompleted': isCompleted,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}


class Schedule {
  final String id;
  final String subjectId;
  final String dayOfWeek; // 'Lunes', 'Martes', etc.
  final String startTime; // e.g., '10:00'
  final String endTime;   // e.g., '12:00'
  final String classroom;

  Schedule({
    required this.id,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.classroom,
  });

  factory Schedule.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Schedule(
      id: doc.id,
      subjectId: data['subjectId'] ?? '',
      dayOfWeek: data['dayOfWeek'] ?? 'Lunes',
      startTime: data['startTime'] ?? '00:00',
      endTime: data['endTime'] ?? '00:00',
      classroom: data['classroom'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'subjectId': subjectId,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'classroom': classroom,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class ScheduleItem {
  final String id;
  final String subjectName;
  final String professorName;
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  ScheduleItem({
    required this.id,
    required this.subjectName,
    required this.professorName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}


class Grade {
  final String id;
  final String subjectId; // Relación con la materia
  final String name;
  final double percentage;
  final double? score; // Puede ser null si aún no se ha calificado
  final double maxScore;
  final DateTime createdAt;

  Grade({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.percentage,
    this.score,
    required this.maxScore,
    required this.createdAt,
  });

  factory Grade.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Grade(
      id: doc.id,
      subjectId: data['subjectId'] ?? '',
      name: data['name'] ?? '',
      percentage: (data['percentage'] ?? 0).toDouble(),
      score: data['score'] != null ? (data['score'] as num).toDouble() : null,
      maxScore: (data['maxScore'] ?? 10).toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'subjectId': subjectId,
      'name': name,
      'percentage': percentage,
      'score': score,
      'maxScore': maxScore,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}