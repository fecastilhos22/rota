import 'dart:io';
import 'package:flutter/material.dart';
import '../data/models/atendimento_model.dart';
import '../data/models/historico_item_model.dart';

class DetalheHistoricoView extends StatelessWidget {
  const DetalheHistoricoView({super.key});

  Widget _montarFoto(AtendimentoModel atendimento) {
    if (atendimento.sincronizado == 0) {
      if (atendimento.caminhoFoto == null) return const Text('Sem foto');
      return Image.file(
        File(atendimento.caminhoFoto!),
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, erro, pilha) =>
            const Text('Não foi possível abrir a foto'),
      );
    }

    if (atendimento.fotoUrl == null) return const Text('Sem foto');
    return Image.network(
      atendimento.fotoUrl!,
      height: 250,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progresso) {
        if (progresso == null) return child;
        return const SizedBox(
          height: 250,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, erro, pilha) =>
          const Text('Não foi possível carregar a foto'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as HistoricoItemModel;
    final atendimento = item.atendimento;

    return Scaffold(
      appBar: AppBar(title: Text('Chamado ${atendimento.chamadoId}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.codigoCliente} - ${item.nomeCliente}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(atendimento.sincronizado == 1 ? 'Status: Sincronizado' : 'Status: Pendente de Envio'),
            const SizedBox(height: 16),
            const Text('Categoria do parecer', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(atendimento.categoriaTecnico),
            const SizedBox(height: 12),
            const Text('Procedimento realizado', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(atendimento.descricaoProcedimento),
            const SizedBox(height: 12),
            const Text('Data de conclusão', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(atendimento.dataResolucao),
            const SizedBox(height: 16),
            _montarFoto(atendimento),
          ],
        ),
      ),
    );
  }
}