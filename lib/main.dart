import 'package:flutter/material.dart';
import 'package:gestao_lactare/theme/app_colors.dart';

import 'package:gestao_lactare/ui/screens/login_screen.dart';
import 'package:gestao_lactare/navigation/app_navigation.dart';

void main() {
  runApp(const LactareApp());
}

class LactareApp extends StatelessWidget {
  const LactareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lactare Connect',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      onGenerateRoute: AppNavigation.generateRoute,
    );
  }
}
