import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serveme/pages/contract_details_page.dart';

// Página onde o freelancer pode ver todos os contratos ativos e passados, com detalhes como nome do estabelecimento, função, datas, status, etc.
class FreelaContractsPage extends StatefulWidget {
  final int userId; // ID do freelancer logado
  const FreelaContractsPage({super.key, required this.userId});

  @override
  State<FreelaContractsPage> createState() => _FreelaContractsPageState();
}

class _FreelaContractsPageState extends State<FreelaContractsPage> {
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
        Uri.parse('http://10.0.2.2:3000/contracts/freela/${widget.userId}'),
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
        title: const Text('Meus Contratos'),
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
                      'Estabelecimento: ${contrato['estabelecimento_nome']}\n'
                      'Início: ${contrato['data_hora_inicio']}\n'
                      'Fim: ${contrato['data_hora_fim']}\n'
                      'Status: ${contrato['status']}',
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContractDetailsPage(
                            contrato: contrato,
                            isFreela: true, // mostra nome do estabelecimento
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
