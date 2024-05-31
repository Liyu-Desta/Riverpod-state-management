import 'package:one/Domain/models/user_model.dart';
import 'package:one/Domain/entities/user.dart';

abstract class UserRepository {
  Future<UserModel?> signup(User user, String password);
  Future<UserModel?> login(String email, String password);
  Future<void> logout();
  Future<String?> getCurrentUser();
}
