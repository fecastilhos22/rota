import 'package:flutter/material.dart';
import '../data/models/historico_item_model.dart';
import '../viewModel/historico_view_model.dart';

class HistoricoView extends StatefulWidget {
  const HistoricoView({super.key});

  @override
  State<HistoricoView> createState() => _HistoricoViewState();
}

class _HistoricoViewState extends State<HistoricoView> {
  final HistoricoViewModel _viewModel = HistoricoViewModel();
  bool _modoGrade = false;

  @override
  void initState() {
    super.initState();
    _viewModel.carregar();
  }

  Widget _badge(bool sincronizado) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: sincronizado ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        sincronizado ? 'Sincronizado' : 'Pendente de Envio',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _card(HistoricoItemModel item) {
    final atendimento = item.atendimento;
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detalhe-historico', arguments: item);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chamado ${atendimento.chamadoId} - ${item.codigoCliente}',
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(item.nomeCliente, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(atendimento.categoriaTecnico, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              _badge(atendimento.sincronizado == 1),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [

          IconButton(
            icon: Icon(_modoGrade ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _modoGrade = !_modoGrade;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: _viewModel.filtrar,
              decoration: const InputDecoration(
                hintText: 'Buscar por ID do chamado ou código do cliente',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                if (_viewModel.carregando) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_viewModel.itens.isEmpty) {
                  return const Center(child: Text('Nenhum atendimento encontrado'));
                }
                if (_modoGrade) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: _viewModel.itens.length,
                    itemBuilder: (context, index) => _card(_viewModel.itens[index]),
                  );
                }
                return ListView.builder(
                  itemCount: _viewModel.itens.length,
                  itemBuilder: (context, index) => _card(_viewModel.itens[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}