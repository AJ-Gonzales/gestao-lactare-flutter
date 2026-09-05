import 'package:flutter/material.dart';
import 'package:gestao_lactare/theme/app_colors.dart';

import '../../navigation/app_routes.dart';

class DashboardMenu extends StatelessWidget {
  const DashboardMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MenuItem(
          titulo: 'Nutrizes',
          rota: AppRoutes.nutrizes,
        ),
        _MenuItem(
          titulo: 'Doações',
          rota: AppRoutes.doacoes,
        ),
        _MenuItem(
          titulo: 'Agendamentos',
          rota: AppRoutes.agendamentos,
        ),
        _MenuItem(
          titulo: 'Avaliações',
          rota: AppRoutes.avaliacoes,
        ),
        _MenuItem(
          titulo: 'Sair',
          rota: AppRoutes.login,
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String titulo;
  final String rota;

  const _MenuItem({
    required this.titulo,
    required this.rota,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, rota);
        },
        style: TextButton.styleFrom(
          foregroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
        ),
        child: Text(
          titulo,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}