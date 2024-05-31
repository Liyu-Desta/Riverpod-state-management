import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/Domain/repositories/user_repository.dart';
import 'package:one/Infrastructure/data_providers/signInDataProvider.dart';
import 'package:one/Infrastructure/repositories/user_repository_impl.dart';
import 'package:one/Infrastructure/data_providers/auth_api_service.dart';
import 'package:one/Application/riverpod/login_riverpod.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService();
});

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  final authApiService = ref.watch(authApiServiceProvider);
  return UserRepositoryImpl(apiService: authApiService);
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return AuthNotifier(userRepository as UserRepository);
});
