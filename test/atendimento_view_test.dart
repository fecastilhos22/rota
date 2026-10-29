import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota/data/models/chamado_model.dart';
import 'package:rota/view/atendimento_view.dart';

final chamadoDeTeste = ChamadoModel(
  id: 1,
  codigoCliente: 'CLI-1',
  nomeCliente: 'Maria Silva',
  categoriaInformada: 'Lentidao',
  descricaoProblema: 'Internet lenta',
  enderecoCliente: 'Rua A, 10',
  bairro: 'Centro',
  cidade: 'Chapeco',
  latitude: -27.1,
  longitude: -52.6,
  criadoEm: '2026-10-01 10:00:00',
  status: 'aberto',
);


Widget _app() {
  return MaterialApp(
    routes: {
      '/': (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/atendimento',
                  arguments: chamadoDeTeste,
                ),
                child: const Text('abrir'),
              ),
            ),
          ),
      '/atendimento': (context) => const AtendimentoView(),
    },
  );
}

void main() {
  testWidgets('mostra os dados do chamado e os campos do formulario', (tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    expect(find.text('CLI-1 - Maria Silva'), findsOneWidget);
    expect(find.text('Categoria do parecer técnico'), findsOneWidget);
    expect(find.text('Descrição do procedimento'), findsOneWidget);
    expect(find.text('Câmera'), findsOneWidget);
    expect(find.text('Galeria'), findsOneWidget);
  });

  testWidgets('formulario vazio mostra os avisos e a SnackBar', (tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    final botao = find.text('Concluir atendimento');
    await tester.ensureVisible(botao);
    await tester.pumpAndSettle();
    await tester.tap(botao);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Escolha uma categoria'), findsOneWidget);
    expect(find.text('Descreva com pelo menos 10 caracteres'), findsOneWidget);
    expect(find.text('Preencha os campos obrigatórios'), findsOneWidget);
  });
}