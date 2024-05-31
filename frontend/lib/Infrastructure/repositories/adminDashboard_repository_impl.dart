import '../../domain/models/opportunities.dart';
import '../../Domain/repositories/adminDashboard_repository.dart';
import '../../Infrastructure/data_providers/adminDashboard_api.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  @override
  Future<void> addOpportunity(Opportunity opportunity) async {
    await AdminDashboardApi.addOpportunity(opportunity);
  }

  @override
  Future<void> updateOpportunity(String id, Opportunity opportunity) async {
    await AdminDashboardApi.updateOpportunity(id, opportunity);
  }

  @override
  Future<void> deleteOpportunity(String id) async {
    await AdminDashboardApi.deleteOpportunity(id);
  }

  @override
  Future<List<Opportunity>> fetchOpportunities() async {
    return await AdminDashboardApi.fetchOpportunities();
  }
}
