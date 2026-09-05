import 'package:flutter/material.dart';
import 'package:gestao_lactare/theme/app_colors.dart';

import '../../navigation/app_routes.dart';

import '../components/dashboard_menu.dart';
import '../components/doacoes_chart.dart';
import '../components/agendamentos_chart.dart';
import '../components/bancos_chart.dart';
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Painel de gerenciamento',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    const DashboardMenu(),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Column(
                  children: [
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

                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Expanded(child: BancosChart()),

                          const SizedBox(width: 14),

                          Expanded(child: AlertaCard()),
                        ],
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
