import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'landing_page.dart';
import 'signup_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'delete_account_screen.dart';
import 'account_deleted_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LandingPage()),

    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),

    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    GoRoute(
      path: '/delete-account',
      builder: (context, state) => const DeleteAccountScreen(),
    ),

    GoRoute(
      path: '/account-deleted',
      builder: (context, state) => const AccountDeletedScreen(),
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
