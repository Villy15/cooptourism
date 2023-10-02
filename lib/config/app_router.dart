import 'package:cooptourism/auth/auth.dart';
import 'package:cooptourism/pages/coops_page.dart';
import 'package:cooptourism/pages/home_feed_page.dart';
import 'package:cooptourism/pages/home_page.dart';
import 'package:cooptourism/pages/market_page.dart';
import 'package:cooptourism/pages/menu_page.dart';
import 'package:cooptourism/pages/profile_page.dart';
import 'package:cooptourism/pages/selected_coop_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import auth pages
import 'package:cooptourism/auth/login_page.dart';
import 'package:cooptourism/auth/register_page.dart';

final GoRouter router = GoRouter(routes: <GoRoute>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthPage();
      },
      routes: [
        GoRoute(
            path: 'coops_page',
            builder: (BuildContext context, GoRouterState state) {
              return const AuthPage();
            },
            routes: [
              GoRoute(
                  path: ':coopId',
                  builder: (BuildContext context, GoRouterState state) {
                    return SelectedCoopPage(
                        coopId: state.pathParameters["coopId"]!);
                  })
            ]),
        GoRoute(
          path: 'market_page',
          builder: (BuildContext context, GoRouterState state) {
            return const MarketPage();
          },
        ),
        GoRoute(
          path: 'profile_page',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfilePage();
          },
        ),
        GoRoute(
          path: 'menu_page',
          builder: (BuildContext context, GoRouterState state) {
            return const MenuPage();
          },
        ),


        // // AUTH ROUTES
        // GoRoute(
        //   path: 'register_page',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const RegisterPage();
        //   },
        // ),
        // GoRoute(
        //   path: 'login_page',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const LoginPage();
        //   },
        // ),

        
      ]),
]);
