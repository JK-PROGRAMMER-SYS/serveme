import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Página que exibe uma lista de vagas abertas para freelancers.
// O freelancer pode clicar em uma vaga para aceitar e criar um contrato.
class FreelaJobsPage extends StatefulWidget {
  final int freelaId; // ID do freelancer logado

  const FreelaJobsPage({super.key, required this.freelaId});

  @override
  State<FreelaJobsPage> createState() => _FreelaJobsPageState();
}

class _FreelaJobsPageState extends State<FreelaJobsPage> {
  List<dynamic> jobs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/jobs/list'),
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jobs = jsonDecode(response.body);
          loading = false;
        });
      } else {
        if (!mounted) return;
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar vagas: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro inesperado: $e')));
    }
  }

  Future<void> _aceitarVaga(int jobId) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/contracts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"job_id": jobId, "freela_id": widget.freelaId}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vaga aceita com sucesso!')),
        );
        _fetchJobs();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao aceitar vaga: ${response.statusCode}'),
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
        title: const Text('Vagas Abertas'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
          ? const Center(child: Text('Nenhuma vaga disponível'))
          : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('${job['funcao']} - ${job['estab_nome']}'),
                    subtitle: Text(
                      'Início: ${job['data_hora_inicio']}\n'
                      'Fim: ${job['data_hora_fim']}\n'
                      'Valor: R\$${job['valor']}',
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _aceitarVaga(job['id']),
                      child: const Text('Aceitar'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
