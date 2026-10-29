import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota/view/login_view.dart';

void main() {
  testWidgets('mostra titulo, tagline, campos e botao', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    expect(find.text('Rota'), findsOneWidget);
    expect(find.text('Chamados em rota'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('campos vazios mostram os avisos de validacao', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.text('Digite o e-mail'), findsOneWidget);
    expect(find.text('Digite a senha'), findsOneWidget);
  });

  testWidgets('e-mail sem arroba mostra aviso de e-mail invalido', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    await tester.enterText(find.byType(TextFormField).first, 'semarroba');
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.text('E-mail inválido'), findsOneWidget);
  });
}
