import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:share_nest_app/main.dart' as app;
void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Admin Actions: Add Resource and Verify', (tester) async{
    app.main();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'admin@sharenest.com');
    await tester.enterText(find.byType(TextField).at(1), 'admin123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ADD'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'New Admin Tool');
    await tester.enterText(find.byType(TextFormField).at(1), 'A new tool added by admin');
    await tester.tap(find.text('Add Resource'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('BROWSE'));
    await tester.pumpAndSettle();
    expect(find.text('New Admin Tool'), findsOneWidget);
  });
}
