import 'package:go_router/go_router.dart';
import '../../features/resource/presentation/screens/add_resource_screen.dart';
import '../../features/resource/presentation/screens/browse_resources_screen.dart';
import '../../features/resource/presentation/screens/my_loan_screen.dart';
import '../../features/reservation/presentation/screens/reservation_form_screen.dart';
import '../../features/reservation/presentation/screens/reservation_confirmation_screen.dart';
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
    ],
  );
}
