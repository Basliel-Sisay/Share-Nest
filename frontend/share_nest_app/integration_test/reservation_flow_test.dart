import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:share_nest_app/main.dart' as app;
void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Reservation Flow: Search, Details, Request', (tester) async{
    app.main();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Drill');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Drill').first);
    await tester.pumpAndSettle();
    expect(find.text('Drill'), findsWidgets);
    expect(find.text('Confirm Reservation'), findsOneWidget);
    await tester.tap(find.text('Confirm Reservation'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm Reservation'), findsOneWidget); 
  });
}
