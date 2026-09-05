import 'package:flutter/material.dart';
import 'package:gestao_lactare/theme/app_colors.dart';

import 'package:gestao_lactare/navigation/app_navigation.dart';
import 'package:gestao_lactare/ui/screens/splash_screen.dart';

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
      home: const SplashScreen(),
      onGenerateRoute: AppNavigation.generateRoute,
    );
  }
}
