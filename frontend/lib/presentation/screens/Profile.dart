import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one/Domain/models/userProfile_model.dart';
import 'package:one/Infrastructure/data_providers/userProfile_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

void main() {
  runApp(ProviderScope(child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserProfilePage(),
  )));
}

class UserProfilePage extends ConsumerStatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showSaveButton = false;

  @override
  void initState() {
    super.initState();
    ref.read(userProfileNotifierProvider.notifier).fetchUserProfile();
    _scrollController.addListener(_scrollListener);
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

  void _updateProfilePicture(Uint8List profileImageBytes) {
    ref.read(userProfileNotifierProvider.notifier).updateProfilePicture(profileImageBytes);
  }

  void _updateField(String fieldName, String value) {
    final notifier = ref.read(userProfileNotifierProvider.notifier);
    switch (fieldName) {
      case 'userName':
        notifier.updateUserName(value);
        break;
      case 'email':
        notifier.updateEmail(value);
        break;
      case 'phoneNumber':
        notifier.updatePhoneNumber(value);
        break;
      case 'bio':
        notifier.updateBio(value);
        break;
      case 'location':
        notifier.updateLocation(value);
        break;
      case 'interests':
        notifier.updateInterests(value);
        break;
      case 'socialMedia':
        notifier.updateSocialMedia(value);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfileNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Admin Profile',
      ),
      body: userProfileState.isLoading
          ? Center(child: CircularProgressIndicator())
          : userProfileState.userProfile == null
              ? Center(child: Text('Failed to load profile: ${userProfileState.errorMessage}'))
              : _buildProfileContent(userProfileState.userProfile!),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: _showSaveButton,
        child: CustomButton(
          text: 'Save',
          onPressed: () {
            _saveUserProfile();
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(UserProfile userProfile) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(40),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      final bytes = await pickedFile.readAsBytes();
                      _updateProfilePicture(bytes);
                    }
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: userProfile.profileImageBytes != null
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(userProfile.profileImageBytes!),
                            radius: 60,
                          )
                        : Center(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20),
                _buildProfileField(
                  labelText: 'Admin Name',
                  initialValue: userProfile.userName,
                  onChanged: (value) => _updateField('userName', value),
                ),
                SizedBox(height: 16.0),
                _buildProfileField(
                  labelText: 'Email',
                  initialValue: userProfile.email,
                  onChanged: (value) => _updateField('email', value),
                ),
                SizedBox(height: 16.0),
                _buildProfileField(
                  labelText: 'Phone Number',
                  initialValue: userProfile.phoneNumber,
                  onChanged: (value) => _updateField('phoneNumber', value),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.grey),
                _buildAdditionalProfileFeature(
                  icon: Icons.person,
                  title: 'Bio',
                  subtitle: 'Add a short description about yourself',
                  inputValue: userProfile.bio,
                  onTap: (value) {
                    _showInputDialog(userProfile.bio, (value) {
                      _updateField('bio', value);
                    });
                  },
                ),
                _buildAdditionalProfileFeature(
                  icon: Icons.location_on,
                  title: 'Location',
                  subtitle: 'Add or update your current location',
                  inputValue: userProfile.location,
                  onTap: (value) {
                    _showInputDialog(userProfile.location, (value) {
                      _updateField('location', value);
                    });
                  },
                ),
                _buildAdditionalProfileFeature(
                  icon: Icons.tag,
                  title: 'Interests',
                  subtitle: 'Add or update your interests or hobbies',
                  inputValue: userProfile.interests,
                  onTap: (value) {
                    _showInputDialog(userProfile.interests, (value) {
                      _updateField('interests', value);
                    });
                  },
                ),
                _buildAdditionalProfileFeature(
                  icon: Icons.link,
                  title: 'Social Media',
                  subtitle: 'Connect your social media profiles',
                  inputValue: userProfile.socialMedia,
                  onTap: (value) {
                    _showInputDialog(userProfile.socialMedia, (value) {
                      _updateField('socialMedia', value);
                    });
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileField({
    required String labelText,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: Icon(Icons.edit, color: Colors.purple),
        labelStyle: TextStyle(
          color: Colors.purple,
          fontFamily: 'Roboto',
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildAdditionalProfileFeature({
    required IconData icon,
    required String title,
    required String subtitle,
    required String inputValue,
    required ValueChanged<String> onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.purple),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Roboto',
            ),
          ),
          onTap: () {
            onTap(inputValue);
          },
        ),
        if (inputValue.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              inputValue,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        Divider(color: Colors.grey),
      ],
    );
  }

  void _showInputDialog(String initialValue, Function(String) onSave) {
    String inputValue = initialValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter'),
          content: TextFormField(
            initialValue: initialValue,
            onChanged: (value) => inputValue = value,
            decoration: InputDecoration(
              hintText: 'Enter',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(inputValue);
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _saveUserProfile() {
    final notifier = ref.read(userProfileNotifierProvider.notifier);
    final userProfile = ref.read(userProfileNotifierProvider).userProfile!;
    notifier.updateUserName(userProfile.userName);
    notifier.updateEmail(userProfile.email);
    notifier.updatePhoneNumber(userProfile.phoneNumber);
    notifier.updateBio(userProfile.bio);
    notifier.updateLocation(userProfile.location);
    notifier.updateInterests(userProfile.interests);
    notifier.updateSocialMedia(userProfile.socialMedia);
  }
}
