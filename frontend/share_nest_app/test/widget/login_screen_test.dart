import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_nest_app/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen shows required fields and handles validation', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    final loginButtonFinder = find.text('Login');
    await tester.dragUntilVisible(
      loginButtonFinder,
      find.byType(ListView),
      const Offset(0, -200),
    );
 
    await tester.tap(loginButtonFinder);
    await tester.pump();

    expect(find.text('Please enter your email address'), findsOneWidget);
  });
}
