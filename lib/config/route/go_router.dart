import 'package:cooptourism/config/auth.dart';
import 'package:cooptourism/pages/auth/login_page.dart';
import 'package:cooptourism/pages/auth/register_page.dart';
import 'package:cooptourism/pages/cooperatives/coops_page.dart';
import 'package:cooptourism/pages/error/error_page.dart';
import 'package:cooptourism/pages/home_feed/home_feed_page.dart';
import 'package:cooptourism/pages/home_page.dart';
import 'package:cooptourism/pages/manager/dashboard_page.dart';
import 'package:cooptourism/pages/manager/members_page.dart';
import 'package:cooptourism/pages/manager/reports_page.dart';
import 'package:cooptourism/pages/market/market_page.dart';
import 'package:cooptourism/pages/menu_page.dart';
import 'package:cooptourism/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey(debugLabel: 'shell');

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigator,
    debugLogDiagnostics: true,
    initialLocation: SplashPage.routeLocation,
    routes: [
      GoRoute(
        path: "/splash",
        name: "Splash",
        builder: (context, state) => SplashPage(key: state.pageKey),
      ),
      GoRoute(
        path: "/login",
        name: "Login",
        builder: (context, state) => LoginPage(key: state.pageKey),
      ),
      GoRoute(
        path: "/register",
        name: "Register",
        builder: (context, state) => RegisterPage(key: state.pageKey),
      ),
      ShellRoute(
          navigatorKey: _shellNavigator,
          builder: (context, state, child) {
            String title = getTitle(state.location);
            return HomePage(key: state.pageKey, appTitle: title, child: child);
          },
          routes: [
            GoRoute(
                path: "/",
                name: "Home Feed",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: HomeFeedPage(key: state.pageKey));
                }),
            GoRoute(
                path: "/menu_page",
                name: "Menu",
                pageBuilder: (context, state) {
                  return NoTransitionPage(child: MenuPage(key: state.pageKey));
                }),

            // MEMBER ROUTES
            GoRoute(
                path: "/coops_page",
                name: "Coops",
                pageBuilder: (context, state) {
                  return NoTransitionPage(child: CoopsPage(key: state.pageKey));
                }),
            GoRoute(
                path: "/market_page",
                name: "Market",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: MarketPage(key: state.pageKey));
                }),
            GoRoute(
                path: "/profile_page",
                name: "Profile",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: ProfilePage(key: state.pageKey));
                }),

            // ADMIN ROUTES
            GoRoute(
                path: "/dashboard_page",
                name: "Dashboard",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: DashboardPage(key: state.pageKey));
                }),
            GoRoute(
                path: "/members_page",
                name: "Members",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: MembersPage(key: state.pageKey));
                }),
            GoRoute(
                path: "/reports_page",
                name: "Reports",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: ReportsPage(key: state.pageKey));
                }),
          ])
    ],
    redirect: (context, state) {
      // If our async state is loading, don't perform redirects, yet
      if (authState.isLoading || authState.hasError) return null;

      // Here we guarantee that hasData == true, i.e. we have a readable value

      // This has to do with how the FirebaseAuth SDK handles the "log-in" state
      // Returning `null` means "we are not authorized"
      final isAuth = authState.valueOrNull != null;

      final isSplash = state.location == SplashPage.routeLocation;
      if (isSplash) {
        return isAuth ? "/" : "/login";
      }

      final isLoggingIn = state.location == '/login';
      if (isLoggingIn) return isAuth ? '/' : null;

      return isAuth ? null : SplashPage.routeLocation;
    },
    errorBuilder: (context, state) => RouteErrorScreen(
      errorMsg: state.error.toString(),
      key: state.pageKey,
    ),
  );
});

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  static String get routeName => 'splash';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Make it a circualr loading
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

String getTitle(String location) {
  switch (location) {
    case '/':
      return "Home";
    case '/coops_page':
      return "Cooperatives";
    case '/market_page':
      return "Market";
    case '/profile_page':
      return "Profile";
    case '/menu_page':
      return "Menu";
    case '/dashboard_page':
      return "Dashboard";
    case '/members_page':
      return "Members";
    case '/reports_page':
      return "Reports";
    default:
      return "Home";
  }
}
