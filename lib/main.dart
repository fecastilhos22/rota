import 'package:flutter/material.dart';
import 'view/home_view.dart';
import 'view/login_view.dart';
import 'view/splash_view.dart';
import 'view/atendimento_view.dart';

void main() {
  runApp(const RotaApp());
}

class RotaApp extends StatelessWidget {
  const RotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rota',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashView(),
        '/login': (context) => const LoginView(),
        '/home': (context) => const HomeView(),
        '/atendimento': (context) => const AtendimentoView(),
      },
    );
  }
}