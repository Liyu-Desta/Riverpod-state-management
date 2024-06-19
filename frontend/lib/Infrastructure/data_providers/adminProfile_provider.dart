import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:one/Application/riverpod/adminProfile_notifier.dart';
import 'package:one/Infrastructure/repositories/adminProfile_Repository.dart';

final adminProfileRepositoryProvider = Provider<AdminProfileRepository>((ref) {
  // Implement and return your repository
  throw UnimplementedError();
});

final adminProfileNotifierProvider = StateNotifierProvider<AdminProfileNotifier, AdminProfileState>((ref) {
  final repository = ref.watch(adminProfileRepositoryProvider);
  return AdminProfileNotifier(repository);
});
