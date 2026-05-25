import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EstabContractsPage extends StatefulWidget {
  final int userId; // ID do estabelecimento logado
  const EstabContractsPage({super.key, required this.userId});

  @override
  State<EstabContractsPage> createState() => _EstabContractsPageState();
}

class _EstabContractsPageState extends State<EstabContractsPage> {
  List<dynamic> contracts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchContracts();
  }

  Future<void> _fetchContracts() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/contracts/estab/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          contracts = jsonDecode(response.body);
          loading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar contratos: ${response.statusCode}'),
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
        title: const Text('Contratos do Estabelecimento'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : contracts.isEmpty
          ? const Center(child: Text('Nenhum contrato encontrado'))
          : ListView.builder(
              itemCount: contracts.length,
              itemBuilder: (context, index) {
                final contrato = contracts[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Função: ${contrato['funcao']}'),
                    subtitle: Text(
                      'Freelancer: ${contrato['freelancer_nome']}\n'
                      'Início: ${contrato['data_hora_inicio'] ?? contrato['data_confirmacao']}\n'
                      'Fim: ${contrato['data_hora_fim'] ?? '-'}\n'
                      'Status: ${contrato['status']}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
