import 'package:cooptourism/pages/events/events_page.dart';
import 'package:cooptourism/pages/events/selected_events_page.dart';
import 'package:cooptourism/pages/market/listing_edit.dart';
import 'package:cooptourism/pages/market/listing_messages.dart';
import 'package:cooptourism/pages/tasks/tasks_page.dart';
import 'package:cooptourism/providers/auth.dart';
import 'package:cooptourism/pages/auth/login_or_register.dart';
import 'package:cooptourism/pages/cooperatives/coops_page.dart';
import 'package:cooptourism/pages/cooperatives/selected_coop_page.dart';
import 'package:cooptourism/pages/error/error_page.dart';
import 'package:cooptourism/pages/home_feed/comments/post_comments.dart';
import 'package:cooptourism/pages/home_feed/home_feed_page.dart';
import 'package:cooptourism/pages/home_page.dart';
import 'package:cooptourism/pages/inbox/inbox_page.dart';
import 'package:cooptourism/pages/manager/dashboard/dashboard_page.dart';
import 'package:cooptourism/pages/manager/members_page.dart';
import 'package:cooptourism/pages/manager/reports_page.dart';
import 'package:cooptourism/pages/market/market_page.dart';
import 'package:cooptourism/pages/market/selected_listing_page.dart';
import 'package:cooptourism/pages/menu_page.dart';
import 'package:cooptourism/pages/profile/profile_page.dart';
import 'package:cooptourism/pages/wallet/wallet_page.dart';
import 'package:cooptourism/pages/wiki/selected_wiki_page.dart';
import 'package:cooptourism/pages/wiki/wiki_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:cooptourism/pages/inbox/chat.dart';
// import 'package:cooptourism/data/repositories/user_repository.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey(debugLabel: 'shell');

// final UserRepository _userRepository = UserRepository();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  // Print current location

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
        builder: (context, state) => LoginOrRegister(key: state.pageKey),
      ),
      ShellRoute(
          navigatorKey: _shellNavigator,
          builder: (context, state, child) {
            return HomePage(key: state.pageKey, child: child);
          },
          routes: [
            GoRoute(
              path: "/",
              name: "Home Feed",
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: HomeFeedPage(key: state.pageKey));
              },
              routes: [
                GoRoute(
                    path: 'posts/comments/:postId',
                    builder: (BuildContext context, GoRouterState state) {
                      return PostCommentsPage(
                        postId: state.pathParameters["postId"]!,
                      );
                    }),
              ],
            ),
            
            GoRoute(
                path: "/tasks_page",
                name: "Tasks",
                pageBuilder: (context, state) {
                  return NoTransitionPage(child: TasksPage(key: state.pageKey));
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
              },
              routes: [
                GoRoute(
                    path: ':coopId',
                    builder: (BuildContext context, GoRouterState state) {
                      return SelectedCoopPage(
                        coopId: state.pathParameters["coopId"]!,
                      );
                    }),
              ],
            ),
            GoRoute(
              path: "/market_page",
              name: "Market",
              pageBuilder: (context, state) {
                return NoTransitionPage(child: MarketPage(key: state.pageKey));
              },
              routes: [
                GoRoute(
                  path: ':listingId',
                  builder: (BuildContext context, GoRouterState state) {
                    return SelectedListingPage(
                      listingId: state.pathParameters["listingId"]!,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'listing_messages',
                      builder: (BuildContext context, GoRouterState state) {
                        return ListingMessages(
                            listingId: state.pathParameters["listingId"]!);
                      },
                    ),
                    GoRoute(
                      path: 'listing_edit',
                      builder: (BuildContext context, GoRouterState state) {
                        return ListingEdit(
                            listingId: state.pathParameters["listingId"]!);
                      },
                    ),
                  ],
                ),
              ],
            ),
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

            GoRoute(
                path: "/wallet_page",
                name: "Wallet",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: WalletPage(key: state.pageKey));
                }),
            GoRoute(
              path: "/inbox_page",
              name: "Inbox",
              pageBuilder: (context, state) {
                return NoTransitionPage(child: InboxPage(key: state.pageKey));
              },
              // routes: [
              //   GoRoute(
              //     path: '/inbox_page/chat/:userId',
              //     name: 'Chat',
              //     // pageBuilder: (context, state) {
              //     //   final userId = state.pathParameters['userId']!;
              //     //   final user = _userRepository.getUser(userId);

              //     //   return MaterialPage(child: ChatScreen(user: userId));
              //     // },
              //   ),
              // ],
            ),
            GoRoute(
              path: "/wiki_page",
              name: "Wiki",
              pageBuilder: (context, state) {
                return NoTransitionPage(child: WikiPage(key: state.pageKey));
              },
              routes: [
                GoRoute(
                    path: ':wikiId',
                    builder: (BuildContext context, GoRouterState state) {
                      return SelectedWikiPage(
                        wikiId: state.pathParameters["wikiId"]!,
                      );
                    }),
              ],
              ),
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
        return isAuth ? "/tasks_page" : "/login";
      }

      final isLoggingIn = state.location == '/login';
      if (isLoggingIn) return isAuth ? '/tasks_page' : null;

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
