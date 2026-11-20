import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_financeiro/main.dart';

void main() {
  testWidgets('Dashboard mostra saldo, metas e resumo do mês', (WidgetTester tester) async {
    // Simula o armazenamento do celular vazio
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const AppFinanceiro());
    await tester.pumpAndSettle();

    expect(find.text('Saldo Disponível'), findsOneWidget);
    expect(find.text('Minhas Metas'), findsOneWidget);
    expect(find.text('Resumo do mês'), findsOneWidget);
  });
}