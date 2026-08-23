import 'package:flutter_test/flutter_test.dart';
import 'package:kids_learning_app/main.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const KidsLearnApp());
    await tester.pump();
    // App should launch successfully - welcome screen title
    expect(find.byType(KidsLearnApp), findsOneWidget);
  });
}
