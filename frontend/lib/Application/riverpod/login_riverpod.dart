import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/Domain/entities/user.dart';
import 'package:one/Domain/models/user_model.dart';
import 'package:one/Domain/repositories/user_repository.dart';
import 'package:one/Infrastructure/data_providers/auth_api_service.dart';
import 'package:one/Infrastructure/repositories/user_repository_impl.dart';

// Enum to represent different authentication statuses
enum AuthStatus { initial, authenticated, unauthenticated, error }

// State class to hold the authentication state
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;

  AuthState({required this.status, this.user, this.error});

  // Factory constructors for different states
  factory AuthState.initial() => AuthState(status: AuthStatus.initial);
  factory AuthState.authenticated(UserModel user) => AuthState(status: AuthStatus.authenticated, user: user);
  factory AuthState.unauthenticated() => AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.error(String error) => AuthState(status: AuthStatus.error, error: error);
}

// StateNotifier to manage authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final UserRepository userRepository;

  AuthNotifier(this.userRepository) : super(AuthState.initial());

  // Method to log in a user
  Future<void> logUser(String email, String password) async {
    try {
      final result = await userRepository.login(email, password);
      
      if (result != null) {
        print("yesssssss");
        state = AuthState.authenticated(result);
      } else {
        state = AuthState.error('Invalid email or password');
      }
    } catch (e) {
      state = AuthState.error('Error occurred while signing in: ${e.toString()}');
    }
  }

  // Method to sign up a user
  Future<void> signUpUser(User user, String password) async {
    try {
      final result = await userRepository.signup(user, password);
      if (result != null) {
        state = AuthState.authenticated(result);
      } else {
        state = AuthState.error('Error occurred while signing up');
      }
    } catch (e) {
      state = AuthState.error('Error occurred while signing up: ${e.toString()}');
    }
  }

  // Method to log out a user
  void logout() {
    userRepository.logout();
    state = AuthState.unauthenticated();
  }
}

// Provider for AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return AuthNotifier(userRepository);
});

// Provider for UserRepository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiService = AuthApiService();
  return UserRepositoryImpl(apiService: apiService);
});
