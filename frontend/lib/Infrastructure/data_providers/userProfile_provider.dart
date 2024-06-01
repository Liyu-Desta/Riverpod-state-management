import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/Infrastructure/repositories/userProfile_repository.dart';

import'package:one/Application/riverpod/userProfile_state.dart';
import'package:one/Application/riverpod/userProfile_notifier.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

final userProfileNotifierProvider = StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UserProfileNotifier(repository);
});
