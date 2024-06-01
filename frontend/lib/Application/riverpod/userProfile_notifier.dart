import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/Domain/models/userProfile_model.dart';
import 'package:one/Application/riverpod/userProfile_state.dart';
import 'package:one/Infrastructure/repositories/userProfile_repository.dart';
import 'dart:typed_data';


class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final UserProfileRepository _repository;

  UserProfileNotifier(this._repository) : super(UserProfileState(isLoading: true)) {
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final userProfile = await _repository.fetchUserProfile();
      state = state.copyWith(userProfile: userProfile, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to fetch user profile: $e', isLoading: false);
    }
  }

  Future<void> updateProfilePicture(Uint8List profileImageBytes) async {
    try {
      await _repository.updateUserProfilePicture(profileImageBytes);
      final updatedProfile = state.userProfile?.copyWith(profileImageBytes: profileImageBytes);
      state = state.copyWith(userProfile: updatedProfile);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update profile picture: $e');
    }
  }

  Future<void> updateUserName(String userName) async {
    try {
      await _repository.updateUserName(userName);
      final updatedProfile = state.userProfile?.copyWith(userName: userName);
      state = state.copyWith(userProfile: updatedProfile);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update user name: $e');
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      await _repository.updateEmail(email);
      final updatedProfile = state.userProfile?.copyWith(email: email);
      state = state.copyWith(userProfile: updatedProfile);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update email: $e');
    }
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    try {
      await _repository.updatePhoneNumber(phoneNumber);
      final updatedProfile = state.userProfile?.copyWith(phoneNumber: phoneNumber);
      state = state.copyWith(userProfile: updatedProfile);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update phone number: $e');
    }
  }

  Future<void> updateBio(String bio) async {
    try {
      await _repository.updateBio(bio);
      final updatedProfile = state.userProfile?.copyWith(bio: bio);
      state = state.copyWith(userProfile: updatedProfile);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update bio: $e');
    }
  }

  Future<void> updateLocation(String location) async {
    try {
      await _repository.updateLocation(location);
      final updatedProfile = state.userProfile?.copyWith(location: location);
      state = state.copyWith(userProfile: updatedProfile);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update location: $e');
    }
  }

  Future<void> updateInterests(String interests) async {
    try {
      await _repository.updateInterests(interests);
      final updatedProfile = state.userProfile?.copyWith(interests: interests);
      state = state.copyWith(userProfile: updatedProfile);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update interests: $e');
    }
  }

  Future<void> updateSocialMedia(String socialMedia) async {
    try {
      await _repository.updateSocialMedia(socialMedia);
      final updatedProfile = state.userProfile?.copyWith(socialMedia: socialMedia);
      state = state.copyWith(userProfile: updatedProfile);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update social media: $e');
    }
  }
}
