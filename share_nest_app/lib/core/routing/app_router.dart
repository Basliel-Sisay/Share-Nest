import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/landing_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/item/presentation/screens/item_detail_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/delete_account_screen.dart';
import '../../features/profile/presentation/screens/account_deleted_screen.dart';
import '../../features/resource/presentation/screens/add_resource_screen.dart';
import '../../features/resource/presentation/screens/browse_resources_screen.dart';
import '../../features/resource/presentation/screens/my_loan_screen.dart';
import '../../features/reservation/presentation/screens/reservation_form_screen.dart';
import '../../features/reservation/presentation/screens/reservation_confirmation_screen.dart';
import '../widgets/custom_bottom_nav.dart';
import '../providers/app_providers.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

bool _isAuthRoute(String path) {
  return path == '/landing' || path == '/login' || path == '/signup';
}

class _AuthRedirectNotifier extends ChangeNotifier {
  bool isAuthenticated = false;

  void update(bool value) {
    if (value != isAuthenticated) {
      isAuthenticated = value;
      notifyListeners();
    }
  }
}

final _authRedirectNotifier = _AuthRedirectNotifier();

final appRouterProvider = Provider<GoRouter>((ref) {
  ref.listen<AuthState>(authProvider, (_, next) {
    _authRedirectNotifier.update(next.isAuthenticated);
  });

  return GoRouter(
    initialLocation: '/landing',
    navigatorKey: _rootNavigatorKey,
    refreshListenable: _authRedirectNotifier,
    redirect: (context, state) {
      final isLoggedIn = _authRedirectNotifier.isAuthenticated;
      final path = state.matchedLocation;

      if (!isLoggedIn && !_isAuthRoute(path)) return '/landing';
      if (isLoggedIn && _isAuthRoute(path)) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          int currentIndex = 0;
          final location = state.uri.path;
          if (location == '/home') currentIndex = 0;
          if (location == '/browse') currentIndex = 1;
          if (location == '/add') currentIndex = 2;
          if (location == '/loans') currentIndex = 3;
          if (location == '/profile') currentIndex = 4;
          return Scaffold(
            body: child,
            bottomNavigationBar: CustomBottomNav(currentIndex: currentIndex),
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/browse',
            builder: (context, state) => const BrowseResourcesScreen(),
          ),
          GoRoute(
            path: '/add',
            builder: (context, state) => const AddResourceScreen(),
          ),
          GoRoute(
            path: '/loans',
            builder: (context, state) => const MyLoanScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/history',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/item/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ItemDetailScreen(resourceId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/delete-account',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: '/account-deleted',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AccountDeletedScreen(),
      ),
      GoRoute(
        path: '/reservation',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReservationFormScreen(),
      ),
      GoRoute(
        path: '/reservation-confirmation',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReservationConfirmationScreen(),
      ),
    ],
  );
});
