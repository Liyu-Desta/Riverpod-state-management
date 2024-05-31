import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/opportunities.dart';
import '../../Domain/repositories/adminDashboard_repository.dart';
import '../../Infrastructure/repositories/adminDashboard_repository_impl.dart';

// Provider for the repository implementation
final adminDashboardRepositoryProvider =
    Provider<AdminDashboardRepository>((ref) {
  return AdminDashboardRepositoryImpl();
});

// StateNotifierProvider for the AdminDashboardNotifier
final adminDashboardNotifierProvider = StateNotifierProvider<
    AdminDashboardNotifier, AsyncValue<List<Opportunity>>>((ref) {
  final repository = ref.watch(adminDashboardRepositoryProvider);
  return AdminDashboardNotifier(repository);
});

class AdminDashboardNotifier
    extends StateNotifier<AsyncValue<List<Opportunity>>> {
  final AdminDashboardRepository _repository;

  AdminDashboardNotifier(this._repository) : super(AsyncValue.loading()) {
    fetchOpportunities();
  }

  Future<void> fetchOpportunities() async {
    try {
      final opportunities = await _repository.fetchOpportunities();
      state = AsyncValue.data(opportunities);
    } catch (e) {
      state = AsyncValue.error(e.toString());
    }
  }

  Future<void> addOpportunity(Opportunity opportunity) async {
    try {
      await _repository.addOpportunity(opportunity);
      fetchOpportunities();
    } catch (e) {
      state = AsyncValue.error(e.toString());
    }
  }

  Future<void> updateOpportunity(
      String id, Opportunity updatedOpportunity) async {
    try {
      await _repository.updateOpportunity(id, updatedOpportunity);
      fetchOpportunities();
    } catch (e) {
      state = AsyncValue.error(e.toString());
    }
  }

  Future<void> deleteOpportunity(String id) async {
    try {
      await _repository.deleteOpportunity(id);
      fetchOpportunities();
    } catch (e) {
      state = AsyncValue.error(e.toString());
    }
  }
}
