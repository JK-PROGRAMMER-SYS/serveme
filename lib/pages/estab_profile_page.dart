import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EstabProfilePage extends StatefulWidget {
  final int userId; // ID do estabelecimento logado
  const EstabProfilePage({super.key, required this.userId});

  @override
  State<EstabProfilePage> createState() => _EstabProfilePageState();
}

class _EstabProfilePageState extends State<EstabProfilePage> {
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController nomeFantasiaController = TextEditingController();
  final TextEditingController razaoSocialController = TextEditingController();

  Future<void> _salvarPerfil() async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/estab/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "cnpj": cnpjController.text,
          "endereco_completo": enderecoController.text,
          "latitude": latitudeController.text.isEmpty
              ? null
              : double.parse(latitudeController.text),
          "longitude": longitudeController.text.isEmpty
              ? null
              : double.parse(longitudeController.text),
          "nome_fantasia": nomeFantasiaController.text,
          "razao_social": razaoSocialController.text,
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
        title: const Text('Gerenciar Perfil Estabelecimento'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cnpjController,
              decoration: const InputDecoration(
                labelText: 'CNPJ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: enderecoController,
              decoration: const InputDecoration(
                labelText: 'Endereço Completo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: latitudeController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: longitudeController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nomeFantasiaController,
              decoration: const InputDecoration(
                labelText: 'Nome Fantasia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: razaoSocialController,
              decoration: const InputDecoration(
                labelText: 'Razão Social',
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
