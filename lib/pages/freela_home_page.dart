import 'package:flutter/material.dart';
import 'freela_profile_page.dart';
import 'freela_contracts_page.dart';
import 'freela_availability_page.dart';

// Página inicial do freelancer após login, com opções para acessar perfil, contratos, disponibilidade, etc.
class FreelaHomePage extends StatelessWidget {
  final int userId;

  const FreelaHomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Freelancer'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Meu Perfil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FreelaProfilePage(userId: userId),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Meus Contratos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FreelaContractsPage(userId: userId),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Disponibilidade'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FreelaAvailabilityPage(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
