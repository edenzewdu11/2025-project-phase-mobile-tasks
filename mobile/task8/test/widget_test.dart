import 'package:flutter_navigation_task7/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App shows "My Products" title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('My Products'), findsOneWidget);
  });
}
