import 'package:flutter/material.dart';
import 'package:gestao_lactare/ui/screens/nutrizes_screen.dart';

import '../ui/screens/login_screen.dart';
import '../ui/screens/dashboard_screen.dart';
import '../ui/screens/agendamentos_screen.dart';
import '../ui/screens/doacoes_screen.dart';
import '../ui/screens/avaliacoes_screen.dart';

import 'app_routes.dart';

class AppNavigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case AppRoutes.nutrizes:
        return MaterialPageRoute(builder: (_) => const NutrizesScreen());

      case AppRoutes.agendamentos:
        return MaterialPageRoute(builder: (_) => const AgendamentosScreen());

      case AppRoutes.doacoes:
        return MaterialPageRoute(builder: (_) => const DoacoesScreen());

      case AppRoutes.avaliacoes:
        return MaterialPageRoute(builder: (_) => const AvaliacoesScreen());

      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
