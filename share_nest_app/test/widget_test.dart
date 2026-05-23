import 'package:flutter_test/flutter_test.dart';

import 'package:share_nest_app/main.dart';

void main() {
  testWidgets('ShareNest app loads browse screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ShareNestApp());
    await tester.pumpAndSettle();

    expect(find.text('Explore Resources'), findsOneWidget);
    expect(find.text('ShareNest'), findsOneWidget);
  });
}
