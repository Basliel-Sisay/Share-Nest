import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_nest_app/core/widgets/custom_bottom_nav.dart';

void main() {
  testWidgets('CustomBottomNav renders correct number of items', (tester) async {
    int selectedIndex = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: CustomBottomNav(
            currentIndex: selectedIndex,
          ),
        ),
      ),
    );
    expect(find.text('HOME'), findsOneWidget);
    expect(find.text('ADD'), findsOneWidget);
  });
}
