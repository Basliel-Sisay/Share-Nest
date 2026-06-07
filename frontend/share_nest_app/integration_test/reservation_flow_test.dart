import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:share_nest_app/main.dart' as app;
void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Reservation Flow: Search, Details, Request', (tester) async{
    app.main();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'admin@sharenest.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'admin123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('BROWSE'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Drill');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Power Drill').first);
    await tester.pumpAndSettle();
    expect(find.text('Power Drill'), findsWidgets);
    await tester.tap(find.text('Reserve Now'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm Reservation'), findsOneWidget);
    await tester.tap(find.text('Confirm Reservation'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm Reservation').last);
    await tester.pumpAndSettle();
    expect(find.text('Reservation Confirmed'), findsOneWidget);
  });
}
