import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';

class DashboardMenu extends StatelessWidget {
  const DashboardMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Navegação',
      icon: const Icon(Icons.menu),
      onSelected: (rota) {
        Navigator.pushNamed(context, rota);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: AppRoutes.nutrizes, child: Text('Nutrizes')),
        const PopupMenuItem(
          value: AppRoutes.agendamentos,
          child: Text('Agendamentos'),
        ),
        const PopupMenuItem(value: AppRoutes.doacoes, child: Text('Doações')),
        const PopupMenuItem(
          value: AppRoutes.avaliacoes,
          child: Text('Avaliações'),
        ),
      ],
    );
  }
}
