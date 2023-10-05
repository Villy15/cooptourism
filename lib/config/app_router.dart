import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cooptourism/pages/auth/auth.dart';
import 'package:cooptourism/pages/cooperatives/coops_page.dart';
import 'package:cooptourism/pages/home_feed/home_feed_page.dart';
// import 'package:cooptourism/pages/home_page.dart';
import 'package:cooptourism/pages/market/market_page.dart';
import 'package:cooptourism/pages/menu_page.dart';
import 'package:cooptourism/pages/profile/profile_page.dart';
import 'package:cooptourism/pages/cooperatives/selected_coop_page.dart';

import 'package:cooptourism/pages/manager/dashboard_page.dart';
import 'package:cooptourism/pages/manager/reports_page.dart';
import 'package:cooptourism/pages/manager/members_page.dart';



final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter router = GoRouter(navigatorKey: _rootNavigatorKey, routes: [
  ShellRoute(
      navigatorKey: _shellNavigatorKey,
      routes: [
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeFeedPage();
          },
          routes: [
            GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: 'coops_page',
                builder: (BuildContext context, GoRouterState state) {
                  return const CoopsPage();
                },
                routes: [
                  GoRoute(
                      parentNavigatorKey: _shellNavigatorKey,
                      path: ':coopId',
                      builder: (BuildContext context, GoRouterState state) {
                        return SelectedCoopPage(
                            coopId: state.pathParameters["coopId"]!);
                      })
                ]),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: 'market_page',
              builder: (BuildContext context, GoRouterState state) {
                return const MarketPage();
              },
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: 'profile_page',
              builder: (BuildContext context, GoRouterState state) {
                return const ProfilePage();
              },
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: 'menu_page',
              builder: (BuildContext context, GoRouterState state) {
                return const MenuPage();
              },
            ),


            // ADMIN ROUTES

            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: 'dashboard_page',
              builder: (BuildContext context, GoRouterState state) {
                return const DashboardPage();
              },
            ),

            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: 'members_page',
              builder: (BuildContext context, GoRouterState state) {
                return const MembersPage();
              },
            ),

            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: 'reports_page',
              builder: (BuildContext context, GoRouterState state) {
                return const ReportsPage();
              },
            ),
          ],
        ),
      ],
      builder: ((context, state, child) {
        return AuthPage(child: child);
      })),
]);
