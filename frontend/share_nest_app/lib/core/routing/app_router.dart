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
import '../../features/profile/presentation/screens/privacy_security_screen.dart';
import '../../features/profile/presentation/screens/help_center.dart';
import '../../features/profile/presentation/screens/confirm_delete_account_screen.dart';
import '../../features/profile/presentation/screens/account_deleted_screen.dart';
import '../../features/resource/presentation/screens/add_resource_screen.dart';
import '../../features/resource/presentation/screens/browse_resources_screen.dart';
import '../../features/resource/presentation/screens/my_loan_screen.dart';
import '../../features/reservation/presentation/screens/reservation_form_screen.dart';
import '../../features/reservation/presentation/screens/reservation_confirmation_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/user_management_screen.dart';
import '../../features/admin/presentation/screens/admin_resource_management_screen.dart';
import '../../features/admin/presentation/screens/admin_loan_management_screen.dart';
import '../widgets/custom_bottom_nav.dart';
import '../providers/app_providers.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

bool _isAuthRoute(String path) {
  return path == '/landing' || path == '/login' || path == '/signup' || path == '/account-deleted';
}

class AuthListenable extends ChangeNotifier {
  AuthListenable(Ref ref) {
    _subscription = ref.listen<AuthState>(
      authProvider,
      (previous, next) {
        if (previous?.isAuthenticated != next.isAuthenticated) {
          notifyListeners();
        }
      },
    );
  }

  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

final authListenableProvider = Provider<AuthListenable>((ref){
  final listenable = AuthListenable(ref);
  ref.onDispose(listenable.dispose);
  return listenable;
});

final appRouterProvider = Provider<GoRouter>((ref){
  final listenable = ref.watch(authListenableProvider);

  return GoRouter(
    initialLocation: '/landing',
    navigatorKey: _rootNavigatorKey,
    refreshListenable: listenable,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authProvider).isAuthenticated;
      final path = state.matchedLocation;

      if (!isLoggedIn && !_isAuthRoute(path)){
        return '/landing';
      }
      if (isLoggedIn && _isAuthRoute(path)){ 
        return '/home';
      }
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
        path: '/privacy-security',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PrivacySecurityScreen(),
      ),
      GoRoute(
        path: '/help-center',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: '/delete-account',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ConfirmDeleteAccountScreen(),
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
      GoRoute(
        path: '/edit-resource/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AddResourceScreen(editResourceId: id);
        },
      ),
      GoRoute(
        path: '/admin',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const UserManagementScreen(),
      ),
      GoRoute(
        path: '/admin/resources',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminResourceManagementScreen(),
      ),
      GoRoute(
        path: '/admin/loans',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminLoanManagementScreen(),
      ),
    ],
  );
});
