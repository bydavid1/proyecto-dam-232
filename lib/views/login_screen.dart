import 'package:flutter/material.dart';
import 'home_screen.dart'; // Importamos la pantalla de destino

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para capturar texto
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _handleLogin() {
    // Aquí iría tu lógica de autenticación futura (Firebase, etc.)
    print("Usuario: ${_userController.text}");
    print("Clave: ${_passController.text}");
    
    // Navegación exitosa al Home (reemplaza la pantalla de login)
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (_) => const HomeScreen())
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              // --- LOGO ---
              Center(
                child: Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  // Icono temporal simulando el logo del libro
                  child: const Icon(
                    Icons.book, 
                    color: Colors.white, 
                    size: 40
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // --- TÍTULO ---
              Text(
                "PLANIFICADOR ESCOLAR",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              
              const SizedBox(height: 50),

              // --- FORMULARIO ---
              const Text(
                "USUARIO",
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.grey
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _userController,
                decoration: const InputDecoration(
                  hintText: "Ingrese su usuario",
                ),
              ),
              
              const SizedBox(height: 20),

              const Text(
                "CONTRASEÑA",
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.grey
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Ingrese su contraseña",
                ),
              ),

              const SizedBox(height: 50),

              // --- BOTÓN ---
              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text("INICIAR SESION"),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}