import 'package:flutter/material.dart';
import 'package:proyecto_dam232/views/login_screen.dart';
// Las importaciones de pantallas anteriores ('subjects_screen.dart', etc.) 
// se han eliminado ya que la nueva estructura del HomeScreen utiliza 
// vistas internas o placeholders.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planificador Escolar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Color principal extraído de tus diseños (#0B1E3B)
        primaryColor: const Color(0xFF0B1E3B),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B1E3B),
          primary: const Color(0xFF0B1E3B),
          secondary: const Color(0xFF1E3A5F),
        ),
        // Estilo predeterminado para inputs
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF3F4F6), // Gris suave de fondo
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: const Color(0xFF0B1E3B), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        // Estilo global de botones elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0B1E3B),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
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
      // La aplicación inicia en la pantalla de Login
      home: const LoginScreen(),
    );
  }
}