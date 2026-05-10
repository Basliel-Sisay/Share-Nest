import 'package:go_router/go_router.dart';


//import '../../features/history/routes/history_routes.dart';
//import '../../features/home/routes/home_routes.dart';
//import '../../features/item/routes/item_routes.dart';

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
