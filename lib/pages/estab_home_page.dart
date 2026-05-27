import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'estab_profile_page.dart';
import 'estab_contracts_page.dart';

class EstabHomePage extends StatefulWidget {
  final int userId;
  const EstabHomePage({super.key, required this.userId});

  @override
  State<EstabHomePage> createState() => _EstabHomePageState();
}

class _EstabHomePageState extends State<EstabHomePage> {
  Map<String, dynamic>? estabData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchEstabData();
  }

  Future<void> _fetchEstabData() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/estab/${widget.userId}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          estabData = jsonDecode(response.body);
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  child: ListTile(
                    title: Text(
                      'Nome Fantasia: ${estabData?['nome_fantasia']}',
                    ),
                    subtitle: Text('Nota média: ${estabData?['nota_media']}'),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Perfil da Empresa'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EstabProfilePage(userId: widget.userId),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.assignment),
                  title: const Text('Contratos'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EstabContractsPage(userId: widget.userId),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
