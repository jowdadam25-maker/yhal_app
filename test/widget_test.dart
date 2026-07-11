import 'package:flutter_test/flutter_test.dart';
import 'package:yhla/main.dart';

void main() {
  testWidgets('App boots successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const YhlaApp());
    await tester.pumpAndSettle();

    expect(find.byType(YhlaApp), findsOneWidget);
  });
}
