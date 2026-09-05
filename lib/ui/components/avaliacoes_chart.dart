import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../service/api_service.dart';
import '../../service/pesquisa_satisfacao_service.dart';

class AvaliacoesChart extends StatelessWidget {
  const AvaliacoesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final service = PesquisaSatisfacaoService(ApiService());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Avaliações',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            const Text(
              'Distribuição das notas',
              style: TextStyle(fontSize: 11),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: FutureBuilder(
                future: service.buscarPesquisas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar avaliações: ${snapshot.error}',
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma avaliação encontrada.'),
                    );
                  }

                  final pesquisas = snapshot.data!;

                  final valores = [
                    pesquisas.where((p) => p.nota == 1).length,
                    pesquisas.where((p) => p.nota == 2).length,
                    pesquisas.where((p) => p.nota == 3).length,
                    pesquisas.where((p) => p.nota == 4).length,
                    pesquisas.where((p) => p.nota == 5).length,
                  ];

                  final maiorValor = valores.reduce((a, b) => a > b ? a : b);

                  return BarChart(
                    BarChartData(
                      maxY: maiorValor == 0 ? 5 : maiorValor + 2,

                      gridData: const FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),

                      borderData: FlBorderData(show: false),

                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                          ),
                        ),

                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const notas = ['1 ★', '2 ★', '3 ★', '4 ★', '5 ★'];

                              if (value.toInt() >= 0 &&
                                  value.toInt() < notas.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    notas[value.toInt()],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                        ),
                      ),

                      barGroups: [
                        for (int i = 0; i < valores.length; i++)
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: valores[i].toDouble(),
                                width: 25,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
