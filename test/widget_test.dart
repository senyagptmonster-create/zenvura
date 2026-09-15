import 'package:flutter_test/flutter_test.dart';
import 'package:zenvura/zenvura_app.dart';

void main() {
  testWidgets('ZenvuraApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZenvuraApp());
    expect(find.text('Box Breathing (Samavritti)'), findsOneWidget);
  });
}
