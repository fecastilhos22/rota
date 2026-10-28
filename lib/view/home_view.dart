import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';
import '../viewModel/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.carregar();
  }

  Future<void> _sair() async {
    await AuthRepository().sair();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rota - Chamados'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _viewModel.carregar),
          IconButton(icon: const Icon(Icons.logout), onPressed: _sair),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.carregando) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              // Aviso de modo offline
              if (_viewModel.offline)
                Container(
                  width: double.infinity,
                  color: Colors.orange,
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Modo offline: mostrando dados salvos no celular',
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: _viewModel.chamados.isEmpty
                    ? const Center(child: Text('Nenhum chamado aberto'))
                    : ListView.builder(
                        itemCount: _viewModel.chamados.length,
                        itemBuilder: (context, index) {
                          final chamado = _viewModel.chamados[index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${chamado.codigoCliente} - ${chamado.nomeCliente}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Categoria: ${chamado.categoriaInformada}'),
                                  Text(chamado.descricaoProblema),
                                  Text(chamado.enderecoCompleto),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}