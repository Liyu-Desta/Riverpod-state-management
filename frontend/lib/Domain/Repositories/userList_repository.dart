// userList_repository.dart

import 'package:one/Domain/models/userList_model.dart';

abstract class UserListRepository {
  Future<List<userList>> fetchUserList();
  Future<void> updateRole(userList updatedUser);
}
