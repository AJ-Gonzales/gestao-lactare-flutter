import 'package:flutter/material.dart';

import '../../service/api_service.dart';
import '../../service/pesquisa_satisfacao_service.dart';

class AlertaCard extends StatelessWidget {
  final VoidCallback? onTap;

  const AlertaCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final service = PesquisaSatisfacaoService(ApiService());

    return Card(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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

              final problemas = pesquisas.where((p) => p.nota < 3).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 20),

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

                      const Text('Ver todas →', style: TextStyle(fontSize: 11)),
                    ],
                  ),

                  if (problemas.isEmpty) ...[
                    const SizedBox(height: 16),

                    const Text(
                      'Nenhuma avaliação abaixo de 3 estrelas.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],

                  if (problemas.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        itemCount: problemas.length,
                        separatorBuilder: (_, _) => const Divider(height: 12),
                        itemBuilder: (context, index) {
                          final avaliacao = problemas[index];

                          return _Avaliacao(
                            nome: 'Nutriz #${avaliacao.nutrizId}',
                            nota: '${avaliacao.nota} ★',
                            comentario:
                                avaliacao.comentario ?? 'Sem comentário.',
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.person_outline, size: 18),

        const SizedBox(width: 8),

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

                  Text(nota, style: const TextStyle(fontSize: 11)),
                ],
              ),

              const SizedBox(height: 2),

              Text(
                comentario,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
