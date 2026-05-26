import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Página que exibe uma lista de freelancers disponíveis para contratação.
class FreelaListPage extends StatefulWidget {
  const FreelaListPage({super.key});

  @override
  State<FreelaListPage> createState() => _FreelaListPageState();
}

class _FreelaListPageState extends State<FreelaListPage> {
  List<dynamic> freelancers = [];

  @override
  void initState() {
    super.initState();
    _fetchFreelancers();
  }

  Future<void> _fetchFreelancers() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/users'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!mounted) return; // 🔹 garante que o widget ainda existe
        setState(() {
          freelancers = data.where((u) => u['tipo'] == 'freelancer').toList();
        });
      }
    } catch (e) {
      if (!mounted) return; // 🔹 evita usar context se o widget foi desmontado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar freelancers: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freelancers Disponíveis'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: freelancers.length,
        itemBuilder: (context, index) {
          final freela = freelancers[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(freela['nome']),
              subtitle: Text('Contato: ${freela['contato']}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Futuramente: abrir perfil detalhado do freelancer
              },
            ),
          );
        },
      ),
    );
  }
}
