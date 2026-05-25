import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'job_page.dart'; // importa a tela de vagas
import 'estab_profile_page.dart';
import 'freela_list_page.dart';

class MenuPage extends StatelessWidget {
  final int userId; // ID do estabelecimento logado

  const MenuPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/serveme_logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Text(
              'Menu Principal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Encontrar Freelancer'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FreelaListPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.work),
              label: const Text('Ofertas de Trabalho'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobPage(estabId: userId),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.business),
              label: const Text('Gerenciar Estabelecimento'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EstabProfilePage(userId: userId),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
