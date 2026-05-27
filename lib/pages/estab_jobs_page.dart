import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Página onde o estabelecimento pode criar uma nova vaga de trabalho
class EstabJobsPage extends StatefulWidget {
  final int estabId; // ID do estabelecimento logado
  const EstabJobsPage({super.key, required this.estabId});

  @override
  State<EstabJobsPage> createState() => _EstabJobsPageState();
}

class _EstabJobsPageState extends State<EstabJobsPage> {
  final TextEditingController funcaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  DateTime? inicio;
  DateTime? fim;

  Future<void> _criarVaga() async {
    if (funcaoController.text.isEmpty ||
        valorController.text.isEmpty ||
        inicio == null ||
        fim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/jobs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "estab_id": widget.estabId, // campo correto no BD
          "funcao": funcaoController.text,
          "data_hora_inicio": inicio!.toIso8601String(),
          "data_hora_fim": fim!.toIso8601String(),
          "valor": double.parse(valorController.text),
          "status": "aberta", // garante status inicial
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return; // ✅ protege antes do Navigator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vaga criada com sucesso!')),
        );
        Navigator.pop(context); // volta para tela anterior
      } else {
        if (!mounted) return; // ✅ protege antes de usar context
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar vaga: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro inesperado: $e')));
    }
  }

  Future<void> _selecionarDataHora(bool inicioFlag) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date == null) return;
    if (!mounted) return; // ✅ protege antes de usar context
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );

    if (time == null) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (inicioFlag) {
        inicio = selected;
      } else {
        fim = selected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicar Vaga'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: funcaoController,
              decoration: const InputDecoration(
                labelText: 'Função (ex: Garçom, Cozinheiro)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor da vaga (R\$)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selecionarDataHora(true),
                    child: Text(
                      inicio == null
                          ? 'Selecionar início'
                          : 'Início: ${inicio.toString()}',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selecionarDataHora(false),
                    child: Text(
                      fim == null ? 'Selecionar fim' : 'Fim: ${fim.toString()}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _criarVaga,
              child: const Text('Publicar Vaga'),
            ),
          ],
        ),
      ),
    );
  }
}
