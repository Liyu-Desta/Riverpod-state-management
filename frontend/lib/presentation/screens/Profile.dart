import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one/Domain/models/adminProfile_model.dart';

import 'package:one/Infrastructure/data_providers/adminProfile_provider.dart';
import 'package:one/presentation/widgets/custom_alert_dialog.dart';
import 'package:one/presentation/widgets/custom_app_bar.dart';
import 'package:one/presentation/widgets/custom_button.dart';

class AdminProfilePage extends ConsumerStatefulWidget {
  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends ConsumerState<AdminProfilePage> {
  String _adminName = '';
  String _email = '';
  String _phoneNumber = '';
  Uint8List? _profileImageData;
  bool _showSaveButton = false;
  String _password = '';

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(adminProfileNotifierProvider.notifier).fetchAdminProfile();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
      setState(() {
        _showSaveButton = true;
      });
    } else {
      setState(() {
        _showSaveButton = false;
      });
    }
  }

  void _updateProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImageData = bytes;
      });

      ref.read(adminProfileNotifierProvider.notifier).updateProfilePicture(bytes);
    }
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Change Password',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Current Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'New Password',
                ),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Text(
                _password.length >= 8
                    ? 'Valid password'
                    : 'Password must be at least 8 characters long',
                style: TextStyle(
                  color: _password.length >= 8 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _password.length >= 8
                  ? () {
                      ref.read(adminProfileNotifierProvider.notifier).changePassword(_password);
                      Navigator.of(context).pop();
                    }
                  : null,
              child: Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _saveAdminInformation() {
    final updatedProfile = AdminProfile(
      adminName: _adminName,
      email: _email,
      phoneNumber: _phoneNumber,
      profileImageBytes: _profileImageData,
    );

    ref.read(adminProfileNotifierProvider.notifier).saveAdminProfile();
  }

  @override
  Widget build(BuildContext context) {
    final adminProfileState = ref.watch(adminProfileNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Admin Profile',
        actions: _showSaveButton
            ? [
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: _saveAdminInformation,
                ),
              ]
            : null,
      ),
      body: adminProfileState.isLoading
          ? Center(child: CircularProgressIndicator())
          : adminProfileState.errorMessage != null
              ? Center(child: Text(adminProfileState.errorMessage!))
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImageData != null
                              ? MemoryImage(_profileImageData!)
                              : adminProfileState.adminProfile?.profileImageBytes != null
                                  ? MemoryImage(adminProfileState.adminProfile!.profileImageBytes!)
                                  : null,
                        ),
                        TextButton(
                          onPressed: _updateProfilePicture,
                          child: Text('Change Profile Picture'),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue: adminProfileState.adminProfile?.adminName,
                          decoration: InputDecoration(
                            labelText: 'Admin Name',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _adminName = value;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue: adminProfileState.adminProfile?.email,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue: adminProfileState.adminProfile?.phoneNumber,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _phoneNumber = value;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _changePassword,
                          child: Text('Change Password'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
