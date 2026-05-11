import 'package:go_router/go_router.dart';
import '../../features/resource/presentation/screens/add_resource_screen.dart';
import '../../features/resource/presentation/screens/browse_resources_screen.dart';
import '../../features/resource/presentation/screens/my_loan_screen.dart';
import '../../features/reservation/presentation/screens/reservation_form_screen.dart';
import '../../features/reservation/presentation/screens/reservation_confirmation_screen.dart';
<<<<<<< HEAD
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/item/presentation/screens/item_detail_screen.dart';

class AppRouter {
  const AppRouter._();

  // Route paths
  static const String homePath = '/';
  static const String historyPath = '/history';
  static const String itemPath = '/item';

  // Route names
  static const String homeRoute = 'home';
  static const String historyRoute = 'history';
  static const String itemDetailRoute = 'item-detail';

  static final GoRouter router = GoRouter(
    initialLocation: homePath,
    routes: [
      GoRoute(
        path: homePath,
        name: homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: historyPath,
        name: historyRoute,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: itemPath,
        name: itemDetailRoute,
        builder: (context, state) => const ItemDetailScreen(),
      ),
    ],
  );
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
=======
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

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/landing',
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
      GoRoute(
>>>>>>> cc091f2aa79a72349f0d42e4f0a7f612c9e6e530
        path: '/',
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
        path: '/reservation',
        builder: (context, state) => const ReservationFormScreen(),
      ),
      GoRoute(
        path: '/reservation-confirmation',
        builder: (context, state) => const ReservationConfirmationScreen(),
      ),
<<<<<<< HEAD
=======
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/item',
        builder: (context, state) => const ItemDetailScreen(),
      ),
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
>>>>>>> cc091f2aa79a72349f0d42e4f0a7f612c9e6e530
    ],
  );
}
