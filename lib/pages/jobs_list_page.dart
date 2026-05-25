import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JobsListPage extends StatefulWidget {
  const JobsListPage({super.key});

  @override
  State<JobsListPage> createState() => _JobsListPageState();
}

class _JobsListPageState extends State<JobsListPage> {
  List<dynamic> jobs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/jobs'));
      if (response.statusCode == 200) {
        if (!mounted) return; // ✅ protege aqui
        setState(() {
          jobs = jsonDecode(response.body);
          loading = false;
        });
      } else {
        if (!mounted) return; // ✅ protege aqui
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar vagas: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return; // ✅ protege aqui também
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro inesperado: $e')));
    }
  }

  Future<void> _aceitarVaga(int jobId, int freelaId) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/contracts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"job_id": jobId, "freela_id": freelaId}),
      );

      if (!mounted) return; // ✅ protege aqui

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
      if (!mounted) return; // ✅ protege aqui também
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
                    title: Text('${job['funcao']} - R\$${job['valor']}'),
                    subtitle: Text(
                      'Início: ${job['data_hora_inicio']}\nFim: ${job['data_hora_fim']}',
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _aceitarVaga(job['id'], 1); // exemplo: freelaId fixo
                      },
                      child: const Text('Aceitar'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
