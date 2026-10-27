import 'package:flutter/material.dart';
import '../viewModel/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final LoginViewModel _viewModel = LoginViewModel();

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;

    final deuCerto = await _viewModel.entrar(
      _emailController.text.trim(),
      _senhaController.text,
    );

    if (!mounted) return;

    if (deuCerto) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_viewModel.erro ?? 'Erro ao entrar')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Rota', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                const Text('Chamados em rota'),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) return 'Digite o e-mail';
                    if (!valor.contains('@')) return 'E-mail inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) return 'Digite a senha';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _viewModel.carregando ? null : _entrar,
                        child: _viewModel.carregando
                            ? const CircularProgressIndicator()
                            : const Text('Entrar'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}