// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/academic_models.dart';

class AcademicDataManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Subject> _subjects = [];
  List<Event> _events = [];
  List<ScheduleItem> _scheduleItems = [];
  List<Grade> _grades = [];

  List<Subject> get subjects => _subjects;
  List<Event> get events => _events;
  List<ScheduleItem> get schedule => _scheduleItems;
  List<Grade> get grades => _grades;

  StreamSubscription<QuerySnapshot>? _subjectsSub;
  StreamSubscription<QuerySnapshot>? _eventsSub;
  StreamSubscription<QuerySnapshot>? _scheduleSub;
  StreamSubscription<QuerySnapshot>? _gradesSubscription;

  AcademicDataManager() {
    _auth.authStateChanges().listen((User? user) {
      _stopListeners();
      if (user != null) {
        print("👤 Sesión iniciada con: ${user.email}");
        _startListeners(user.uid);
      } else {
        print("🚫 Sesión cerrada, listeners detenidos.");
      }
    });
  }

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("No hay usuario autenticado");
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> _collection(String name) {
    return _firestore.collection('users').doc(_userId).collection(name);
  }

  // listeners
  void _startListeners(String uid) {
    // Materias
    _subjectsSub = _collection('subjects').snapshots().listen((snapshot) {
      _subjects = snapshot.docs
          .map((doc) => Subject.fromFirestore(doc))
          .toList();
      notifyListeners();
    }, onError: (e) => print("Error en materias: $e"));

    // Eventos
    _eventsSub = _collection('events').snapshots().listen((snapshot) {
      _events = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
      notifyListeners();
    }, onError: (e) => print("Error en eventos: $e"));

    // Horario
    _scheduleSub = _collection('schedule').snapshots().listen((snapshot) {
      _scheduleItems = snapshot.docs.map((doc) {
        final s = Schedule.fromFirestore(doc);
        final subject = getSubjectById(s.subjectId);
        return ScheduleItem(
          id: s.id,
          subjectName: subject?.name ?? 'Materia no encontrada',
          professorName: subject?.professor ?? s.classroom,
          dayOfWeek: s.dayOfWeek,
          startTime: s.startTime,
          endTime: s.endTime,
        );
      }).toList();
      notifyListeners();
    }, onError: (e) => print("Error en horario: $e"));

    // Calificaciones
    _gradesSubscription = _collection('grades').snapshots().listen((snapshot) {
      _grades = snapshot.docs.map((doc) => Grade.fromFirestore(doc)).toList();
      notifyListeners();
    }, onError: (e) => print("Error en calificaciones: $e"));
  }

  void _stopListeners() {
    _subjectsSub?.cancel();
    _eventsSub?.cancel();
    _scheduleSub?.cancel();
    _gradesSubscription?.cancel();
    _subjects = [];
    _events = [];
    _scheduleItems = [];
    _grades = [];
    notifyListeners();
    print("🛑 Listeners detenidos y datos vaciados.");
  }

  @override
  void dispose() {
    _stopListeners();
    super.dispose();
  }

  /// cruds
  Future<void> addSubject(Subject subject) async {
    try {
      await _collection('subjects').add(subject.toFirestore());
      print("Materia '${subject.name}' agregada.");
    } catch (e) {
      print("Error al agregar materia: $e");
    }
  }

  Future<void> updateSubject(Subject subject) async {
    try {
      await _collection(
        'subjects',
      ).doc(subject.id).update(subject.toFirestore());
      print("Materia '${subject.name}' actualizada.");
    } catch (e) {
      print("Error al actualizar materia: $e");
    }
  }

  Future<void> deleteSubject(String id) async {
    try {
      await _collection('subjects').doc(id).delete();
      print("Materia eliminada: $id");

      // Eliminar eventos y horarios relacionados
      final events = await _collection(
        'events',
      ).where('subjectId', isEqualTo: id).get();
      for (var e in events.docs) {
        await e.reference.delete();
      }

      final schedules = await _collection(
        'schedule',
      ).where('subjectId', isEqualTo: id).get();
      for (var s in schedules.docs) {
        await s.reference.delete();
      }
    } catch (e) {
      print("Error al eliminar materia: $e");
    }
  }

  Subject? getSubjectById(String id) {
    return _subjects.firstWhereOrNull((s) => s.id == id);
  }

  // -------------------------------------------------------------
  // 🔹 CRUD: EVENTS (Tareas / Exámenes)
  // -------------------------------------------------------------
  Future<void> addEvent(Event event) async {
    try {
      await _collection('events').add(event.toFirestore());
      print("Evento '${event.title}' agregado.");
    } catch (e) {
      print("Error al agregar evento: $e");
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await _collection('events').doc(event.id).update(event.toFirestore());
      print("Evento '${event.title}' actualizado.");
    } catch (e) {
      print("Error al actualizar evento: $e");
    }
  }

  Future<void> updateEventCompletion(String id, bool completed) async {
    try {
      await _collection('events').doc(id).update({'isCompleted': completed});
      print("Evento actualizado: $id");
    } catch (e) {
      print("Error al cambiar estado de evento: $e");
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _collection('events').doc(id).delete();
      print("Evento eliminado: $id");
    } catch (e) {
      print("Error al eliminar evento: $e");
    }
  }

  Future<Event?> getEventById(String id) async {
    try {
      final doc = await _collection('events').doc(id).get();
      if (doc.exists) return Event.fromFirestore(doc);
    } catch (e) {
      print("Error al obtener evento: $e");
    }
    return null;
  }

  // crud schedule
  Future<void> addSchedule(Schedule schedule) async {
    try {
      await _collection('schedule').add(schedule.toFirestore());
      print("Horario agregado (${schedule.dayOfWeek}).");
    } catch (e) {
      print("Error al agregar horario: $e");
    }
  }

  Future<void> updateSchedule(Schedule schedule) async {
    try {
      await _collection(
        'schedule',
      ).doc(schedule.id).update(schedule.toFirestore());
      print("Horario actualizado: ${schedule.id}");
    } catch (e) {
      print("Error al actualizar horario: $e");
    }
  }

  Future<void> deleteSchedule(String id) async {
    try {
      await _collection('schedule').doc(id).delete();
      print("Horario eliminado: $id");
    } catch (e) {
      print("Error al eliminar horario: $e");
    }
  }

  Future<Schedule?> getScheduleById(String id) async {
    try {
      final doc = await _collection('schedule').doc(id).get();
      if (doc.exists) return Schedule.fromFirestore(doc);
    } catch (e) {
      print("Error al obtener horario: $e");
    }
    return null;
  }

  Future<void> addGrade(Grade grade) async {
    try {
      await _collection('grades').add(grade.toFirestore());
      print("Calificación '${grade.name}' agregada.");
    } catch (e) {
      print("Error al agregar calificación: $e");
    }
  }

  Future<void> updateGrade(Grade grade) async {
    try {
      await _collection('grades').doc(grade.id).update(grade.toFirestore());
      print("Calificación '${grade.name}' actualizada.");
    } catch (e) {
      print("Error al actualizar calificación: $e");
    }
  }

  Future<void> deleteGrade(String gradeId) async {
    try {
      await _collection('grades').doc(gradeId).delete();
      print("Calificación eliminada: $gradeId");
    } catch (e) {
      print("Error al eliminar calificación: $e");
    }
  }

  List<Grade> getGradesBySubject(String subjectId) {
    return _grades.where((g) => g.subjectId == subjectId).toList();
  }

  // utulities
  List<Event> get todayActivities {
    final now = DateTime.now();
    return _events.where((e) {
      return e.dueDate.year == now.year &&
          e.dueDate.month == now.month &&
          e.dueDate.day == now.day;
    }).toList();
  }


  Future<void> addScheduleItem(ScheduleItem item) async {
    final subject = _subjects.firstWhereOrNull(
      (s) => s.name.toLowerCase() == item.subjectName.toLowerCase(),
    );

    final schedule = Schedule(
      id: item.id,
      subjectId: subject?.id ?? 'sin_asignar',
      dayOfWeek: item.dayOfWeek,
      startTime: item.startTime,
      endTime: item.endTime,
      classroom: item.professorName,
    );

    await addSchedule(schedule);
  }
}

// extension para firstWhereOrNull
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
