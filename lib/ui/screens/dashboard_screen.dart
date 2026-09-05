

import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';

import '../components/dashboard_menu.dart';
import '../components/doacoes_chart.dart';
import '../components/agendamentos_chart.dart';
import '../components/bancos_chart.dart';
import '../components/avaliacoes_chart.dart';
import '../components/alerta_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // CABEÇALHO
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Painel de gerenciamento',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          'Visão geral da operação de doação de leite.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const DashboardMenu(),
                ],
              ),

              const SizedBox(height: 14),

              // CONTEÚDO
              Expanded(
                child: Column(
                  children: [
                    // PRIMEIRA LINHA
                    Expanded(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Expanded(flex: 2, child: DoacoesChart()),

                          const SizedBox(width: 14),

                          const Expanded(child: AgendamentosChart()),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // SEGUNDA LINHA
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Expanded(child: BancosChart()),

                          const SizedBox(width: 14),

                          const Expanded(child: AvaliacoesChart()),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ALERTA
                    Expanded(
                      flex: 1,
                      child: AlertaCard(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.avaliacoes);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
