import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Página onde o freelancer pode atualizar seu status de disponibilidade (disponível ou indisponível) para receber propostas de trabalho.
class FreelaAvailabilityPage extends StatefulWidget {
  final int userId; // ID do freelancer logado
  const FreelaAvailabilityPage({super.key, required this.userId});

  @override
  State<FreelaAvailabilityPage> createState() => _FreelaAvailabilityPageState();
}

class _FreelaAvailabilityPageState extends State<FreelaAvailabilityPage> {
  String disponibilidade = 'disponivel';

  Future<void> _salvarDisponibilidade() async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/freela/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"disponibilidade_status": disponibilidade}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disponibilidade atualizada com sucesso!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao salvar disponibilidade: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro inesperado: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disponibilidade Freelancer'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: disponibilidade,
              items: const [
                DropdownMenuItem(
                  value: 'disponivel',
                  child: Text('Disponível'),
                ),
                DropdownMenuItem(
                  value: 'indisponivel',
                  child: Text('Indisponível'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  disponibilidade = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Status de Disponibilidade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _salvarDisponibilidade,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
