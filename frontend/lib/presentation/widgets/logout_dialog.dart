import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/Application/riverpod/login_riverpod.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text('Confirm Logout'),
      content: Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Perform logout actions here
            ref.read(authNotifierProvider.notifier).logout();
            GoRouter.of(context).push('/login');
          },
          child: Text('Logout'),
        ),
      ],
    );
  }
}
