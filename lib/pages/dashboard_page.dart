import 'package:flutter/material.dart';
import 'login_page.dart';
import 'job_page.dart';
import 'jobs_list_page.dart';
import 'estab_profile_page.dart';
import 'freela_profile_page.dart';
import 'freela_availability_page.dart';
import 'freela_contracts_page.dart';
import 'estab_contracts_page.dart';

class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> user; // dados do usuário logado

  const DashboardPage({super.key, required this.user});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String nome = user['nome'] ?? 'Usuário';
    final String tipo = user['tipo'] ?? 'desconhecido';
    final int userId = user['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ServeMe'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Bem-vindo, $nome ($tipo)',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Botões diferentes conforme tipo
            if (tipo == 'estabelecimento') ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobPage(estabId: userId),
                    ),
                  );
                },
                child: const Text('Oferta de trabalho'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EstabProfilePage(userId: userId),
                    ),
                  );
                },
                child: const Text('Gerenciar Estabelecimento'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EstabContractsPage(userId: userId),
                    ),
                  );
                },
                child: const Text('Meus Contratos'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Aqui poderia abrir tela de busca de freelancers
                },
                child: const Text('Encontrar Freelancer'),
              ),
            ] else if (tipo == 'freelancer') ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JobsListPage(),
                    ),
                  );
                },
                child: const Text('Encontrar Vagas'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FreelaProfilePage(userId: userId),
                    ),
                  );
                },
                child: const Text('Gerenciar Perfil'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FreelaAvailabilityPage(userId: userId),
                    ),
                  );
                },
                child: const Text('Disponibilidade'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FreelaContractsPage(userId: userId),
                    ),
                  );
                },
                child: const Text('Meus Contratos'),
              ),
            ],

            const Spacer(),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('SAIR'),
            ),
          ],
        ),
      ),
    );
  }
}
