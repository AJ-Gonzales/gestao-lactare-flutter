import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestao_lactare/theme/app_colors.dart';

import '../../model/banco_de_leite.dart';
import '../../model/doacao.dart';
import '../../service/api_service.dart';
import '../../service/banco_leite_service.dart';
import '../../service/doacao_service.dart';

class BancosChart extends StatelessWidget {
  const BancosChart({super.key});

  @override
  Widget build(BuildContext context) {
    final bancoService = BancoLeiteService(ApiService());
    final doacaoService = DoacaoService(ApiService());

    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Doações por banco de leite',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: FutureBuilder<List<BancoDeLeite>>(
                future: bancoService.buscarBancosDeLeite(),
                builder: (context, bancoSnapshot) {
                  if (bancoSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (bancoSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar bancos: '
                        '${bancoSnapshot.error}',
                      ),
                    );
                  }

                  if (!bancoSnapshot.hasData || bancoSnapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhum banco de leite encontrado.'),
                    );
                  }

                  final bancos = bancoSnapshot.data!;

                  return FutureBuilder<List<Doacao>>(
                    future: doacaoService.buscarDoacoes(),
                    builder: (context, doacaoSnapshot) {
                      if (doacaoSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (doacaoSnapshot.hasError) {
                        return Center(
                          child: Text(
                            'Erro ao carregar doações: '
                            '${doacaoSnapshot.error}',
                          ),
                        );
                      }

                      if (!doacaoSnapshot.hasData) {
                        return const Center(
                          child: Text('Nenhuma doação encontrada.'),
                        );
                      }

                      final doacoes = doacaoSnapshot.data!;

                      final valores = bancos.map((banco) {
                        return doacoes
                            .where((doacao) => doacao.bancoLeiteId == banco.id)
                            .length
                            .toDouble();
                      }).toList();

                      final maiorValor = valores.isEmpty
                          ? 0
                          : valores.reduce((a, b) => a > b ? a : b);

                      final larguraGrafico = bancos.length * 90.0;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: larguraGrafico < 400 ? 400 : larguraGrafico,
                          child: BarChart(
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
                                    reservedSize: 42,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();

                                      if (index < 0 || index >= bancos.length) {
                                        return const SizedBox();
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: SizedBox(
                                          width: 75,
                                          child: Text(
                                            bancos[index].nome,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 9),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              barGroups: [
                                for (int i = 0; i < bancos.length; i++)
                                  BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: valores[i],
                                        width: 30,
                                        borderRadius: BorderRadius.circular(4),
                                        color: AppColors.secondary,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
