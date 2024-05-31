import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one/Application/riverpod/login_riverpod.dart';
import 'package:one/presentation/screens/adminDashboard.dart';
import 'package:one/presentation/screens/menu.dart';
import 'package:one/presentation/screens/signup.dart';
import 'package:one/presentation/screens/userDashboard.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    if (authState.status == AuthStatus.initial || authState.status == AuthStatus.unauthenticated) {
      return _buildLoginForm(context, ref, authState);
    } else if (authState.status == AuthStatus.authenticated) {
      if (authState.user!.role == "admin") {
        return Dashboard();
      } else {
        return MenuApp();
      }
    } else if (authState.status == AuthStatus.error) {
      return Scaffold(body: Center(child: Text(authState.error!)));
    } else {
      return _buildLoginForm(context, ref, authState);
    }
  }

  Widget _buildLoginForm(BuildContext context, WidgetRef ref, AuthState authState) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Fill your credentials to log in',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            if (authState.status == AuthStatus.error) ...[
              SizedBox(height: 24.0),
              Text(
                authState.error ?? 'An error occurred',
                style: TextStyle(color: Colors.red),
              ),
            ],
            SizedBox(height: 24.0),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.purple[50],
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.purple[50],
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref.read(authNotifierProvider.notifier).logUser(
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 55.0),
                      backgroundColor: Colors.purpleAccent,
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 36.0),
                  GestureDetector(
                    onTap: () {
                    GoRouter.of(context).pushReplacement('/signup');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
