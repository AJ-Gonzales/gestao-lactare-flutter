import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../service/api_service.dart';
import '../../service/agendamento_service.dart';

class AgendamentosChart extends StatelessWidget {
  const AgendamentosChart({super.key});

  @override
  Widget build(BuildContext context) {
    final service = AgendamentoService(ApiService());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agendamentos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            const Text(
              'Distribuição por status',
              style: TextStyle(fontSize: 11),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: FutureBuilder(
                future: service.buscarAgendamentos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar agendamentos: ${snapshot.error}',
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhum agendamento encontrado.'),
                    );
                  }

                  final agendamentos = snapshot.data!;

                  final confirmados = agendamentos
                      .where((a) => a.status.toLowerCase() == 'confirmado')
                      .length;

                  final pendentes = agendamentos
                      .where((a) => a.status.toLowerCase() == 'pendente')
                      .length;

                  final cancelados = agendamentos
                      .where((a) => a.status.toLowerCase() == 'cancelado')
                      .length;

                  final valores = [confirmados, pendentes, cancelados];

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
                              const titulos = [
                                'Confirmados',
                                'Pendentes',
                                'Cancelados',
                              ];

                              if (value.toInt() >= 0 &&
                                  value.toInt() < titulos.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    titulos[value.toInt()],
                                    style: const TextStyle(fontSize: 9),
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
                                width: 35,
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
