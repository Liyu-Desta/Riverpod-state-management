import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one/presentation/screens/GetStarted.dart';
import 'package:one/presentation/screens/userDashboard.dart';
import 'package:one/presentation/screens/adminDashboard.dart';
import 'package:one/presentation/screens/signup.dart';
import 'package:one/presentation/screens/loginPage.dart';
import 'package:one/presentation/screens/menu.dart';
import 'package:one/presentation/screens/userList.dart';
import 'package:one/presentation/screens/profile.dart';
import 'package:one/presentation/screens/userProfile.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // final _router =

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // routeInformationParser: _router.routeInformationParser,
      // routerDelegate: _router.routerDelegate,
      // routeInformationProvider: PlatformRouteInformationProvider(
      //   initialRouteInformation: RouteInformation(location: '/'),
      // ),
      title: "Ankelba",
      routerConfig: AppRouter.router,
    );
  }
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: AppPath.login,
        builder: (BuildContext context, GoRouterState state) =>
            LoginScreen(),
      ),
      GoRoute(
        path: AppPath.signup,
        builder: (BuildContext context, GoRouterState state) =>
            SignupScreen(),
      ),
      GoRoute(
        path: AppPath.userDashboard,
        builder: (BuildContext context, GoRouterState state) =>
            UserDashboard(),
      ),
      GoRoute(
        path: AppPath.menu,
        builder: (BuildContext context, GoRouterState state) =>
             const Menu(),
      ),
      GoRoute(
        path: AppPath.dashboard,
        builder: (BuildContext context, GoRouterState state) =>
             Dashboard(),
      ),
      GoRoute(
        path: AppPath.userList,
        builder: (BuildContext context, GoRouterState state) =>
             UserList(),
      ),
      // GoRoute(
      //   path: AppPath.profile,
      //   builder: (context, GoRouterState state) =>
      //        AdminProfilePage(),
      // ),
    ],
  );
}

class AppPath {
  static const login = '/login';
  static const signup = '/signup';
  static const dashboard = '/dashboard';
  static const menu = '/menu';
  static const userList = '/userList';
  static const profile = '/profile';
  static const userDashboard = '/userDashboard';
}
