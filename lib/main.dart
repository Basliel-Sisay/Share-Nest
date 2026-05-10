import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF11823B)),
        scaffoldBackgroundColor: const Color(0xFFF1F3F8),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
