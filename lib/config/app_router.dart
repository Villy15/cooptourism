import 'package:cooptourism/auth/auth.dart';
import 'package:cooptourism/pages/home_feed_page.dart';
import 'package:cooptourism/pages/selected_coop_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(routes: <GoRoute>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthPage();
      },
      routes: [
        GoRoute(path: ':coopId',
              builder: (BuildContext context, GoRouterState state) {
                return SelectedCoopPage(coopId: state.pathParameters["coopId"]!);
              }),
        GoRoute(
            path: 'coops_page',
            builder: (BuildContext context, GoRouterState state) {
              return const HomeFeedPage();
            },
            routes: [
              GoRoute(path: ':coopId',
              builder: (BuildContext context, GoRouterState state) {
                return SelectedCoopPage(coopId: state.pathParameters["coopId"]!);
              })
            ]),
        GoRoute(
          path: 'market_page',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeFeedPage();
          },
        ),
        GoRoute(
          path: 'profile_page',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeFeedPage();
          },
        ),
        GoRoute(
          path: 'menu_page',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeFeedPage();
          },
        ),
      ]),
]);
