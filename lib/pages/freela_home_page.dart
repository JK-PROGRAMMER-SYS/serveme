import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'freela_profile_page.dart';
import 'freela_contracts_page.dart';
import 'freela_availability_page.dart';
import 'freela_jobs_page.dart';

class FreelaHomePage extends StatefulWidget {
  final int userId;
  const FreelaHomePage({super.key, required this.userId});

  @override
  State<FreelaHomePage> createState() => _FreelaHomePageState();
}

class _FreelaHomePageState extends State<FreelaHomePage> {
  Map<String, dynamic>? freelaData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchFreelaData();
  }

  Future<void> _fetchFreelaData() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/freela/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          freelaData = jsonDecode(response.body);
          loading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro inesperado: $e')));
    }
  }

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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  child: ListTile(
                    title: Text(
                      'Disponibilidade: ${freelaData?['disponibilidade_status']}',
                    ),
                    subtitle: Text('Nota média: ${freelaData?['nota_media']}'),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Meu Perfil'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FreelaProfilePage(userId: widget.userId),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.assignment),
                  title: const Text('Meus Contratos'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FreelaContractsPage(userId: widget.userId),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Disponibilidade'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FreelaAvailabilityPage(userId: widget.userId),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Encontrar Vagas'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FreelaJobsPage(freelaId: widget.userId),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
