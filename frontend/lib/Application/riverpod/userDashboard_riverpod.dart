// user_dashboard_riverpod.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/Domain/models/userDashboard_model.dart';
import 'package:one/Domain/Repositories/userDashboard_repository.dart';
import 'package:one/Infrastructure/Repositories/userDashboard_repository_impl.dart';

// Provider to create an instance of UserDashboardRepository
final userDashboardRepositoryProvider = Provider<UserDashboardRepository>((ref) {
  return UserDashboardRepositoryImpl();
});

// State Notifier to manage User Dashboard state
class UserDashboardNotifier extends StateNotifier<AsyncValue<List<UserOpportunity>>> {
  final UserDashboardRepository repository;

  UserDashboardNotifier(this.repository) : super(AsyncValue.loading()) {
    _fetchUserOpportunities();
  }

  // Fetch user opportunities from repository
  Future<void> _fetchUserOpportunities() async {
    try {
      final userOpportunities = await repository.fetchUserOpportunities();
      state = AsyncValue.data(userOpportunities);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  // Update a user opportunity
  Future<void> updateUserOpportunity(UserOpportunity userOpportunity) async {
    try {
      await repository.updateUserOpportunity(userOpportunity);
      _fetchUserOpportunities(); // Refresh the list after update
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  // Delete a user opportunity
  Future<void> deleteUserOpportunity(String id) async {
    try {
      await repository.deleteUserOpportunity(id);
      _fetchUserOpportunities(); // Refresh the list after deletion
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }
}

// Provider for UserDashboardNotifier
final userDashboardNotifierProvider = StateNotifierProvider<UserDashboardNotifier, AsyncValue<List<UserOpportunity>>>((ref) {
  final repository = ref.watch(userDashboardRepositoryProvider);
  return UserDashboardNotifier(repository);
});
