import 'package:go_router/go_router.dart';
import '../../features/resource/presentation/screens/add_resource_screen.dart';
import '../../features/resource/presentation/screens/browse_resources_screen.dart';
import '../../features/resource/presentation/screens/my_loan_screen.dart';
import '../../features/reservation/presentation/screens/reservation_form_screen.dart';
import '../../features/reservation/presentation/screens/reservation_confirmation_screen.dart';
import '../../features/auth/presentation/screens/landing_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';

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
