import 'package:flutter_test/flutter_test.dart';
import 'package:smartmush_farmer/main.dart';

void main() {
  testWidgets('shows splash screen branding', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartMushApp());
    await tester.pump();

    expect(find.text('SmartMush Farmer'), findsOneWidget);
    expect(find.text('Controlled Mycology System'), findsOneWidget);
    expect(find.text('Ready.'), findsOneWidget);
  });
}
