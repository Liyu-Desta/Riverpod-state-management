import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one/presentation/widgets/HamburgerMenu.dart';
import 'package:one/Application/riverpod/userList_riverpod.dart';
import 'package:one/Domain/models/userList_model.dart';

class UserList extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userListState = ref.watch(userListNotifierProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 166, 70, 183),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      drawer: HamburgerMenu(
        onUserListTap: () {
          // print("USERLIST ROUTING");
          context.go('/userList');
        },
        onDashboardTap: () {
          // print("DASHBOARD ROUTING");
          context.go('/dashboard');
        },
        onProfileTap: () {
          // print("PROFILE ROUTING");
          context.go('/profile');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userListState.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Text('Failed to fetch user list: $error'),
          data: (userList) => _buildUserList(userList ?? [], ref),
        ),
      ),
    );
  }

  Widget _buildUserList(List<userList> userList, WidgetRef ref) {
    return Column(
      children: [
        Text(
          'Users List',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTableCell('Email'),
                  _buildTableCell('Phone Number'),
                  _buildTableCell('Change Role'),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTableCell(user.email ?? ''),
                      _buildTableCell(user.phoneNumber ?? ''),
                      DropdownButton<String>(
                        value: user.role ?? '',
                        onChanged: (newValue) {
                          if (newValue != null && newValue != user.role) {
                            final updatedUser = user.copyWith(role: newValue);
                            ref.read(userListNotifierProvider.notifier).updateRole(updatedUser);
                          }
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: "user",
                            child: Text("user"),
                          ),
                          DropdownMenuItem<String>(
                            value: "admin",
                            child: Text("admin"),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableCell(String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
