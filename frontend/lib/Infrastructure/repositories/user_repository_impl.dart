import 'package:one/Domain/entities/user.dart';
import 'package:one/Domain/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:one/Domain/repositories/user_repository.dart';
import '../data_providers/auth_api_service.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthApiService apiService;

  UserRepositoryImpl({required this.apiService});

  @override
  Future<UserModel?> signup(User user, String password) async {
    try {
      final response = await apiService.signup(user.name, user.email, password, user.phoneNumber);
      if (response != null && response['access_token'] != null) {
        final userDetail = await apiService.getUserDetail(response['access_token']);
        var userModel = UserModel.fromJson(userDetail!);
        await _storeToken(response['access_token']);
        return userModel;
      }
      return null;
    } catch (e) {
      // Handle error appropriately
      return null;
    }
  }

  @override
 Future<UserModel?> login(String email, String password) async {
    try{
    final response = await apiService.login(email, password);
      print(response);
      if (response != null && response['access_token'] != null) {
        final userDetail = await apiService.getUserDetail(response['access_token']);
        print(userDetail);
        var userModel = UserModel.fromJson(userDetail);
        await _storeToken(response['access_token']);
        return userModel;
      }
    return null;
    }on Exception catch(e){
      return null;
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  @override
  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return token;
  }
}
