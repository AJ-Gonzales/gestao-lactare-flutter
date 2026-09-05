import 'package:flutter/material.dart';

import '../../service/api_service.dart';
import '../../service/pesquisa_satisfacao_service.dart';

class AlertaCard extends StatelessWidget {
  const AlertaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final service = PesquisaSatisfacaoService(ApiService());

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: service.buscarPesquisas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar avaliações: ${snapshot.error}'),
              );
            }

            final pesquisas = snapshot.data ?? [];

            final problemas = pesquisas
                .where((pesquisa) => pesquisa.nota < 3)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 22,
                      color: Colors.orange.shade800,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Avaliações que precisam de atenção',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (problemas.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Nenhuma avaliação abaixo de 3 estrelas.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),

                if (problemas.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 4),
                      itemCount: problemas.length,
                      separatorBuilder: (_, _) {
                        return const SizedBox(height: 14);
                      },
                      itemBuilder: (context, index) {
                        final avaliacao = problemas[index];

                        return _Avaliacao(
                          nome: 'Nutriz #${avaliacao.nutrizId}',
                          nota: '${avaliacao.nota} ★',
                          comentario: avaliacao.comentario ?? 'Sem comentário.',
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Avaliacao extends StatelessWidget {
  final String nome;
  final String nota;
  final String comentario;

  const _Avaliacao({
    required this.nome,
    required this.nota,
    required this.comentario,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.person_outline, size: 20),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        nome,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      nota,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  comentario,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
