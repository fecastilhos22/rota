import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rota - Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthRepository().sair();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: const Center(child: Text('Login funcionou! Home em construção.')),
    );
  }
}