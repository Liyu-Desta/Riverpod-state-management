import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one/Application/riverpod/login_riverpod.dart';
import 'package:one/presentation/screens/GetStarted.dart';
import 'package:one/presentation/screens/userDashboard.dart';
import 'package:one/presentation/screens/adminDashboard.dart';
import 'package:one/presentation/screens/signup.dart'; 
import 'package:one/presentation/screens/loginPage.dart'; // Import the LoginScreen class

void main() {
  runApp(ProviderScope(
      child: MyApp(),));
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  final _router = GoRouter(routes: [
    GoRoute(path: '/',pageBuilder: (context, state) => MaterialPage(child: Material(child: HomeScreen(),)),),
    GoRoute(path: '/login',pageBuilder: (context,state)=>MaterialPage(child: Material(child: LoginScreen(),))),
    GoRoute(path: '/signup',pageBuilder:((context, state) => MaterialPage(child: Material(child: SignupScreen(),)))),
    GoRoute(path: '/userDashboard',pageBuilder: (context, state) => MaterialPage(child: Material(child: UserDashboard(),)),),
    GoRoute(path:'/dashboard',pageBuilder: (context, state) => MaterialPage(child: Material(child: Dashboard(),)),)
  ]);


  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      ),
    );
  }
}
