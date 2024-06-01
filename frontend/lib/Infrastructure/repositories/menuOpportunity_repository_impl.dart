import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one/Domain/Repositories/menuOpportunity_repository.dart';
import 'package:one/Domain/models/menu_opportunity_model.dart';
import 'package:one/Infrastructure/data_providers/auth_api_service.dart';
import 'package:one/Infrastructure/data_providers/menu_opportunity_api.dart';
import 'package:one/Infrastructure/repositories/user_repository_impl.dart';

class MenuOpportunityRepositoryImpl implements MenuOpportunityRepository {
  static const String baseUrl = 'http://localhost:3000';

  @override
  Future<void> registerOpportunity(MenuOpportunity menuOpportunity) async {
    try {
      var userRepository = UserRepositoryImpl(apiService: AuthApiService());
      var token = await userRepository.getCurrentUser();

      if (token == null) {
        throw Exception('Token is null');
      }

      String userId = await MenuDashboardApi.getUserIdFromToken(token);
      String opportunityId = menuOpportunity.id;
      final response = await http.post(
        Uri.parse('$baseUrl/volunteer-opportunities/$opportunityId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'userId': userId, 'opportunityId': opportunityId}),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add opportunity');
      }
    } catch (e) {
      print('Exception during registerOpportunity: $e');
      rethrow;
    }
  }

  @override
  Future<List<MenuOpportunity>> fetchOpportunity() async {
    try {
      var userRepository = UserRepositoryImpl(apiService: AuthApiService());
      var token = await userRepository.getCurrentUser();

      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/volunteer-opportunities'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MenuOpportunity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch opportunities: ${response.body}');
      }
    } catch (e) {
      print('Exception during fetchOpportunity: $e');
      rethrow;
    }
  }
}
