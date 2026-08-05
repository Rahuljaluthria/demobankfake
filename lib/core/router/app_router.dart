import 'package:go_router/go_router.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/shell/shell_screen.dart';
import '../../screens/transfer/transfer_screen.dart';
import '../../screens/transfer/transfer_review_screen.dart';
import '../../screens/transfer/transfer_success_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const ShellScreen(),
    ),
    GoRoute(
      path: '/transfer',
      builder: (context, state) => const TransferScreen(),
    ),
    GoRoute(
      path: '/transfer-review',
      builder: (context, state) => const TransferReviewScreen(),
    ),
    GoRoute(
      path: '/transfer-success',
      builder: (context, state) => const TransferSuccessScreen(),
    ),
  ],
);
