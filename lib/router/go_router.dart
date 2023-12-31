// import 'package:cooptourism/pages/coaching/coaching_messaging.dart';
// import 'package:cooptourism/pages/coaching/coaching_page.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/pages/cooperatives/join_coop.dart';
import 'package:cooptourism/pages/customer/city_page.dart';
import 'package:cooptourism/pages/customer/enroll_coop_page.dart';
import 'package:cooptourism/pages/customer/home_page.dart';
import 'package:cooptourism/pages/events/events_page.dart';
import 'package:cooptourism/pages/events/selected_events_page.dart';
import 'package:cooptourism/pages/inbox/chat.dart';
import 'package:cooptourism/pages/manager/home_page.dart';
import 'package:cooptourism/pages/manager/verify_form.dart';
// import 'package:cooptourism/pages/manager/view_pdf.dart';
import 'package:cooptourism/pages/manager/vote_page.dart';
import 'package:cooptourism/pages/market/add_listing.dart';
import 'package:cooptourism/pages/market/listing_edit.dart';
import 'package:cooptourism/pages/market/listing_messages.dart';
import 'package:cooptourism/pages/market/listing_messages_inbox.dart';
import 'package:cooptourism/pages/market/selected_entertainment_page.dart';
import 'package:cooptourism/pages/market/selected_foodservice_page.dart';
import 'package:cooptourism/pages/market/selected_touring_page.dart';
import 'package:cooptourism/pages/market/selected_transportation_page.dart';

import 'package:cooptourism/pages/member/dashboard.dart';
import 'package:cooptourism/pages/profile/edit_profile.dart';
import 'package:cooptourism/pages/member/member_landing.dart';
import 'package:cooptourism/pages/profile/email_verification.dart';
import 'package:cooptourism/pages/profile/poll_profile_page.dart';
// import 'package:cooptourism/pages/profile/poll_profile_page.dart';
import 'package:cooptourism/pages/tasks/selected_task_page.dart';
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
import 'package:cooptourism/pages/market/selected_accommodations_page.dart';
import 'package:cooptourism/pages/menu_page.dart';
import 'package:cooptourism/pages/profile/profile_page.dart';
import 'package:cooptourism/pages/wallet/wallet_page.dart';
import 'package:cooptourism/pages/wiki/selected_wiki_page.dart';
import 'package:cooptourism/pages/wiki/wiki_page.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:cooptourism/pages/inbox/chat.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final user = ref.watch(userModelProvider);
  String role = user?.role ?? 'Customer';

  // Simplified redirect logic
  String? determineRedirectPath(GoRouterState state) {
    final isAuth = authState.valueOrNull != null;
    final isSplash = state.location == SplashPage.routeLocation;
    final isLoggingIn = state.location == '/login';

    if (authState.isLoading || authState.hasError) {
      // Loading or error state, no redirect
      return null;
    }

    if (!isAuth) {
      // Not authenticated
      return isLoggingIn ? null : '/login';
    }

    // Authenticated
    if (isSplash || isLoggingIn) {
      switch (role) {
        case 'Customer':
          return '/customer_home_page';
        case 'Member':
          return '/member_dashboard_page';
        case 'Manager':
          return '/dashboard_page';
        default:
          return '/'; // Fallback for unexpected roles
      }
    }

    // Already in correct route, no redirect needed
    return null;
  }

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
              path: "/member_dashboard_page",
              name: "Member Dashboard",
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: MemberDashboardPage(key: state.pageKey));
              },
              routes: [
                GoRoute(
                    path: 'tasks_page/:taskId',
                    builder: (BuildContext context, GoRouterState state) {
                      return SelectedTaskPage(
                        taskId: state.pathParameters["taskId"]!,
                      );
                    }),
              ],
            ),

            GoRoute(
                path: "/menu_page",
                name: "Menu",
                pageBuilder: (context, state) {
                  return NoTransitionPage(child: MenuPage(key: state.pageKey));
                }),
            GoRoute(
                path: "/member_charts",
                name: "Member Charts",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: MemberChartsPage(key: state.pageKey));
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
                    },
                    routes: [
                      GoRoute(
                        path: 'join_coop',
                        builder: (BuildContext context, GoRouterState state) {
                          return JoinCoopPage(
                            coopId: state.pathParameters["coopId"]!,
                          );
                        },
                      )
                    ]),
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
                    path: 'add_listing',
                    builder: (BuildContext context, GoRouterState state) {
                      return const AddListing();
                    }),
                GoRoute(
                  path: ':category',
                  builder: (BuildContext context, GoRouterState state) {
                    ListingModel listing = state.extra as ListingModel;
                    switch (state.pathParameters["category"]) {
                      case "Accommodations":
                        return SelectedAccommodationsPage(
                          listing: listing,
                        );
                      case "Transportation":
                        return SelectedTransportationPage(
                          listing: listing,
                        );
                      case "Food Service":
                        return SelectedFoodServicePage(
                          listing: listing,
                        );
                      case "Entertainment":
                        return SelectedEntertainmentPage(
                          listing: listing,
                        );
                      case "Touring":
                        return SelectedTouringPage(
                          listing: listing,
                        );
                      default:
                        return SelectedAccommodationsPage(
                          listing: listing,
                        );
                    }
                  },
                  routes: [
                    GoRoute(
                        path: 'listing_messages_inbox',
                        builder: (BuildContext context, GoRouterState state) {
                          return ListingMessagesInbox(
                              listingId: state.pathParameters["listingId"]!);
                        },
                        routes: [
                          GoRoute(
                            path: ':docId',
                            builder:
                                (BuildContext context, GoRouterState state) {
                              return ListingMessages(
                                  docId: state.pathParameters["docId"]!,
                                  listingId:
                                      state.pathParameters["listingId"]!);
                            },
                          ),
                        ]),
                  ],
                ),
              ],
            ),
            GoRoute(
                path: "/profile_page/:profileId",
                name: "Profile",
                pageBuilder: (context, state) {
                  final profileId = state.pathParameters["profileId"]!;
                  return NoTransitionPage(
                      child: ProfilePage(
                          key: state.pageKey, profileId: profileId));
                },
                routes: [
                  GoRoute(
                      path: 'poll',
                      builder: (BuildContext context, GoRouterState state) {
                        return PollProfilePage(
                          profileId: state.pathParameters["profileId"]!,
                        );
                      }),
                  GoRoute(
                      path: 'enroll_cooperative',
                      builder: (BuildContext context, state) {
                        final profileId = state.pathParameters["profileId"]!;
                        return EnrollCoopPage(
                            key: state.pageKey, profileId: profileId);
                      } // enable navigation to enroll_coop_page.dart
                      ),
                  GoRoute(
                    path: 'edit_profile',
                    builder: (context, state) {
                      final profileId = state.pathParameters["profileId"]!;
                      return EditProfilePage(
                          key: state.pageKey, profileId: profileId);
                    },
                  ),
                  GoRoute(
                    path: 'email_verification',
                    builder: (context, state) {
                      final profileId = state.pathParameters["profileId"]!;
                      return EmailVerificationPage(
                          key: state.pageKey, profileId: profileId);
                    },
                  ),
                  GoRoute(
                    path: 'verify_form/:coopAppId',
                    builder: (context, state) {
                      final coopAppId = state.pathParameters["coopAppId"]!;
                      return VerifyFormPage(
                          key: state.pageKey, coopAppId: coopAppId);
                    },
                  ),
                ]),
            // ADMIN ROUTES
            GoRoute(
                path: "/manager_home_page",
                name: "Manager Home",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: ManagerHomePage(key: state.pageKey));
                }),
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
                },
                routes: [
                  GoRoute(
                      path: ':memberId',
                      builder: (BuildContext context, GoRouterState state) {
                        return ProfilePage(
                          profileId: state.pathParameters["memberId"]!,
                        );
                      }),
                ]),
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
                path: "/vote_page",
                name: "Vote",
                pageBuilder: (context, state) {
                  return NoTransitionPage(child: VotePage(key: state.pageKey));
                }),
            GoRoute(
                path: "/inbox_page",
                name: "Inbox",
                pageBuilder: (context, state) {
                  return NoTransitionPage(child: InboxPage(key: state.pageKey));
                },
                routes: [
                  GoRoute(
                      path: ':userId',
                      name: 'Chat',
                      pageBuilder: (context, state) {
                        return NoTransitionPage(
                            child: ChatScreen(
                                userId: state.pathParameters["userId"]!));
                      })
                ]),
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

            GoRoute(
              path: "/events_page",
              name: "Events",
              pageBuilder: (context, state) {
                return NoTransitionPage(child: EventsPage(key: state.pageKey));
              },
              routes: [
                GoRoute(
                    path: ':eventId',
                    builder: (BuildContext context, GoRouterState state) {
                      return SelectedEventsPage(
                        eventId: state.pathParameters["eventId"]!,
                      );
                    }),
              ],
            ),

            GoRoute(
              path: "/customer_home_page",
              name: "Customer Home",
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: CustomerHomePage(key: state.pageKey));
              },
              routes: [
                GoRoute(
                    path: ':cityId',
                    builder: (BuildContext context, GoRouterState state) {
                      return CityPage(
                        cityId: state.pathParameters["cityId"]!,
                      );
                    }),
              ],
            ),
          ]),
    ],
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return null;
      return determineRedirectPath(state);
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
