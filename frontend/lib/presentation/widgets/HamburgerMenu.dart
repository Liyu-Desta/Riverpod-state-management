import 'package:flutter/material.dart';
import '../widgets/logout_dialog.dart';
import 'package:go_router/go_router.dart';

class HamburgerMenu extends StatelessWidget {
  final VoidCallback onDashboardTap;
  final VoidCallback onUserListTap;
  final VoidCallback onProfileTap;

  const HamburgerMenu({
    Key? key,
    required this.onDashboardTap,
    required this.onUserListTap,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 166, 70, 183),
            ),
            accountName: Text(
              'Ankelba',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            accountEmail: Text(
              'example@email.com', // Replace with the actual email address
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/images/logo.png',
                height: 36,
                width: 36,
              ),
            ),
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: onDashboardTap,
          ),
          ListTile(
            title: Text('User List'),
            onTap: onUserListTap,
          ),
          ListTile(
            title: Text('Profile'),
            onTap: onProfileTap,
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog();
      },
    );
  }
}
