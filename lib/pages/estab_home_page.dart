import 'package:flutter/material.dart';
import 'estab_profile_page.dart';
import 'estab_contracts_page.dart';

//Página inicial do estabelecimento após login, com opções para acessar perfil, contratos, etc.
class EstabHomePage extends StatelessWidget {
  final int userId;

  const EstabHomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Estabelecimento'),
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
            leading: const Icon(Icons.business),
            title: const Text('Perfil da Empresa'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EstabProfilePage(userId: userId),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Contratos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EstabContractsPage(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
