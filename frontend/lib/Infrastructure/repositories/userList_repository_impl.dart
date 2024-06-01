// userList_repository_impl.dart

import 'package:one/Domain/Repositories/userList_repository.dart';
import 'package:one/Domain/models/userList_model.dart';
import 'package:one/infrastructure/data_providers/userList_api.dart';

class UserListRepositoryImpl implements UserListRepository {
  @override
  Future<List<userList>> fetchUserList() async {
    // Implement fetch logic from API or database
    return await userListApi.fetchUserList();
  }

  @override
  Future<void> updateRole(userList updatedUser) async {
    // Implement update logic using API or database
    if (updatedUser.id == null) {
      throw Exception('User ID is required for update');
    }
    await userListApi.updateRole(updatedUser.id!, updatedUser);
  }
}
