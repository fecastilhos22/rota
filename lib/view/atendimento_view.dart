import 'package:flutter/material.dart';
import '../data/models/chamado_model.dart';

class AtendimentoView extends StatelessWidget {
  const AtendimentoView({super.key});

  @override
  Widget build(BuildContext context) {
    // Pega o chamado enviado pela Home
    final chamado = ModalRoute.of(context)!.settings.arguments as ChamadoModel;

    return Scaffold(
      appBar: AppBar(title: Text('Chamado ${chamado.codigoCliente}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('${chamado.nomeCliente}\n\n${chamado.descricaoProblema}'),
      ),
    );
  }
}