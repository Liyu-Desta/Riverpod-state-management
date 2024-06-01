// user_dashboard_repository_impl.dart
import 'package:one/Domain/Repositories/userDashboard_repository.dart';
import 'package:one/Infrastructure/data_providers/userDashboard_api.dart';
import 'package:one/Domain/models/userDashboard_model.dart';

class UserDashboardRepositoryImpl implements UserDashboardRepository {
  @override
  Future<void> updateUserOpportunity(UserOpportunity userOpportunity) async {
    if (userOpportunity.id == null) {
      throw Exception('Opportunity ID is required for update');
    }
    await UserdashboardApi.updateUserOpportunity(userOpportunity.id!, userOpportunity);
  }

  @override
  Future<void> deleteUserOpportunity(String id) async {
    await UserdashboardApi.deleteUserOpportunity(id);
  }

  @override
  Future<List<UserOpportunity>> fetchUserOpportunities() async {
    return await UserdashboardApi.fetchUserOpportunities();
  }
}
