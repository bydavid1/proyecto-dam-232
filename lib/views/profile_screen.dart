import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para el perfil
    const String userName = "Byron David";
    const String userEmail = "byron.david@example.com";
    const String userRole = "Estudiante de Ingeniería en Sistemas";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "PERFIL",
          style: TextStyle(
            color: Color(0xFF0B1E3B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Avatar del Usuario
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0B1E3B), width: 3),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, color: Colors.white, size: 60),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 2. Nombre
            Text(
              userName,
              style: const TextStyle(
                color: Color(0xFF0B1E3B),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 4),

            // 3. Rol
            Text(
              userRole,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 40),

            // 4. Secciones de Información
            _buildProfileCard(
              icon: Icons.email_outlined,
              title: "Correo Electrónico",
              subtitle: userEmail,
              color: Colors.redAccent,
              onTap: () {},
            ),
            
            _buildProfileCard(
              icon: Icons.calendar_today_outlined,
              title: "Horario Académico",
              subtitle: "Ver calendario de clases",
              color: Colors.green,
              onTap: () {
                // Navegar a la vista de horario
              },
            ),

            _buildProfileCard(
              icon: Icons.settings_outlined,
              title: "Configuración",
              subtitle: "Ajustes de la aplicación",
              color: Colors.orange,
              onTap: () {
                // Navegar a la vista de configuración
              },
            ),

            const SizedBox(height: 40),

            // 5. Botón de Cerrar Sesión (Destacado)
            TextButton.icon(
              onPressed: () {
                // Lógica de cerrar sesión
                print("Cerrar Sesión");
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Cerrar Sesión",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ícono
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            
            const SizedBox(width: 16),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF0B1E3B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}