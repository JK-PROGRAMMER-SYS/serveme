import 'package:flutter/material.dart';

// Tela genérica de detalhes de contrato
class ContractDetailsPage extends StatelessWidget {
  final Map<String, dynamic> contrato;
  final bool isFreela; // ✅ agora está definido no construtor

  const ContractDetailsPage({
    super.key,
    required this.contrato,
    required this.isFreela,
  });

  @override
  Widget build(BuildContext context) {
    // Decide dinamicamente qual nome mostrar
    final String outraParte = isFreela
        ? contrato['estabelecimento_nome'] ?? '-'
        : contrato['freelancer_nome'] ?? '-';

    final String outraParteLabel = isFreela ? 'Estabelecimento' : 'Freelancer';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Contrato'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Função: ${contrato['funcao']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$outraParteLabel: $outraParte',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Início: ${contrato['data_hora_inicio'] ?? '-'}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fim: ${contrato['data_hora_fim'] ?? '-'}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Valor: R\$${contrato['valor'] ?? '-'}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: ${contrato['status'] ?? '-'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
