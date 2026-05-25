import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FreelaProfilePage extends StatefulWidget {
  final int userId; // ID do freelancer logado
  const FreelaProfilePage({super.key, required this.userId});

  @override
  State<FreelaProfilePage> createState() => _FreelaProfilePageState();
}

class _FreelaProfilePageState extends State<FreelaProfilePage> {
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController experienciaController = TextEditingController();
  final TextEditingController especialidadesController =
      TextEditingController();
  String disponibilidade = 'disponivel';

  Future<void> _salvarPerfil() async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/freela/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "cpf": cpfController.text,
          "experiencia_texto": experienciaController.text,
          "especialidades": especialidadesController.text.split(
            ',',
          ), // lista separada por vírgula
          "disponibilidade_status": disponibilidade,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar perfil: ${response.statusCode}'),
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
        title: const Text('Gerenciar Perfil Freelancer'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cpfController,
              decoration: const InputDecoration(
                labelText: 'CPF',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: experienciaController,
              decoration: const InputDecoration(
                labelText: 'Experiência',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: especialidadesController,
              decoration: const InputDecoration(
                labelText: 'Especialidades (separadas por vírgula)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
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
              onPressed: _salvarPerfil,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
