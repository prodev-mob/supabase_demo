import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_demo/navigation/page/auth_go_route.dart';
import 'package:supabase_demo/navigation/page/page_not_found/screen/page_not_found_screen.dart';
import 'package:supabase_demo/navigation/route_name_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Routes {
  Routes._();

  static GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => rootKey.currentContext;

  static root(ProviderRef<Object?> ref) => GoRoute(
        path: RouteNameConstant.root,
        redirect: (BuildContext context, GoRouterState state) async {
          User? isUserLogged = Supabase.instance.client.auth.currentUser;

          debugPrint("IsUserLogged :: :: :: :: :: ${isUserLogged?.toJson()}");
          return isUserLogged != null
              ? RouteNameConstant.employeeList
              : RouteNameConstant.auth;
        },
      );

  static final rootRouter = Provider(
    (ref) => GoRouter(
      navigatorKey: rootKey,
      initialLocation: RouteNameConstant.root,
      routerNeglect: false,
      debugLogDiagnostics: true,
      errorBuilder: (context, error) => const PageNotFoundScreen(),
      routes: [
        root(ref),
        AppRoute.auth,
        AppRoute.employeeList,
        AppRoute.employeeAttendance,
        AppRoute.addEmployeeAttendance,
        AppRoute.addEmployee,
      ],
    ),
  );

  static FutureOr<String?> Function(BuildContext, GoRouterState)? redirect() =>
      (context, state) async {
        User? isUserLogged = Supabase.instance.client.auth.currentUser;
        return isUserLogged != null ? RouteNameConstant.employeeList : RouteNameConstant.auth;
      };

  static FutureOr<String?> Function(BuildContext, GoRouterState)? redirectIfLoggedOut() =>
      (context, state) async {
        User? isUserLogged = Supabase.instance.client.auth.currentUser;
        return isUserLogged != null ? null : RouteNameConstant.auth;
      };
}
