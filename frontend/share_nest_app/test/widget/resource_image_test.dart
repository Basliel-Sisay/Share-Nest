import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_nest_app/core/widgets/resource_image.dart';

void main() {
  testWidgets('ResourceImage displays network image', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ResourceImage(
            path: 'https://via.placeholder.com/150',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('ResourceImage displays asset image', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ResourceImage(
            path: 'assets/images/drill.png',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
    expect(find.byType(Image), findsOneWidget);
  });
}
