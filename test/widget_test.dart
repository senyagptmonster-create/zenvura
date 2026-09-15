import 'package:flutter_test/flutter_test.dart';
import 'package:zenvura/zenvura_app.dart';

void main() {
  testWidgets('Zenvura smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZenvuraApp());
    expect(find.byType(ZenvuraApp), findsOneWidget);
  });
}