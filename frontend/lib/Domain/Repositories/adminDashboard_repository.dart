import '../../domain/models/opportunities.dart';

abstract class AdminDashboardRepository {
  Future<void> addOpportunity(Opportunity opportunity);
  Future<void> updateOpportunity(String id, Opportunity opportunity);
  Future<void> deleteOpportunity(String id);
  Future<List<Opportunity>> fetchOpportunities();
}
