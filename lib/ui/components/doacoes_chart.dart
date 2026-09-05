import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../service/api_service.dart';
import '../../service/doacao_service.dart';

class DoacoesChart extends StatelessWidget {
  const DoacoesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final service = DoacaoService(ApiService());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Doações ao longo do tempo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            const Text(
              'Quantidade de doações por mês',
              style: TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: FutureBuilder(
                future: service.buscarDoacoes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar doações: ${snapshot.error}',
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma doação encontrada.'),
                    );
                  }

                  final doacoes = snapshot.data!;

                  final agora = DateTime.now();

                  final meses = List.generate(6, (index) {
                    return DateTime(agora.year, agora.month - 5 + index);
                  });

                  final valores = meses.map((mes) {
                    return doacoes
                        .where((doacao) {
                          final data = DateTime.tryParse(doacao.data);

                          if (data == null) {
                            return false;
                          }

                          return data.year == mes.year &&
                              data.month == mes.month;
                        })
                        .length
                        .toDouble();
                  }).toList();

                  final maiorValor = valores.reduce((a, b) => a > b ? a : b);

                  return LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: maiorValor == 0 ? 5 : maiorValor + 2,

                      gridData: const FlGridData(show: true),

                      borderData: FlBorderData(show: false),

                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < 0 ||
                                  value.toInt() >= meses.length) {
                                return const SizedBox();
                              }

                              final mes = meses[value.toInt()];

                              const nomes = [
                                'Jan',
                                'Fev',
                                'Mar',
                                'Abr',
                                'Mai',
                                'Jun',
                                'Jul',
                                'Ago',
                                'Set',
                                'Out',
                                'Nov',
                                'Dez',
                              ];

                              return Text(
                                nomes[mes.month - 1],
                                style: const TextStyle(fontSize: 11),
                              );
                            },
                          ),
                        ),

                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                          ),
                        ),
                      ),

                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            for (int i = 0; i < valores.length; i++)
                              FlSpot(i.toDouble(), valores[i]),
                          ],

                          isCurved: true,

                          barWidth: 3,

                          dotData: const FlDotData(show: true),

                          belowBarData: BarAreaData(show: true),
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
