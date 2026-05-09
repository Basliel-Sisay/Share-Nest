import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'landing_page.dart';
import 'login_page.dart';
import 'signup_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', 
            builder: (context, state) => const LandingPage()
            ),
    GoRoute(path: '/login',
            builder: (context, state) => const LoginPage()
            ),
    GoRoute(path: '/signup',
            builder: (context, state) => const SignupScreen()
            ),
          ],
  );

void main() {
  runApp(const ShareNestApp());
}

class ShareNestApp extends StatelessWidget {
  const ShareNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ShareNest',
      theme: ThemeData(primarySwatch: Colors.green),
      routerConfig: _router,
    );
  }
}
