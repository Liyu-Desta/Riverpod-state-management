import 'package:one/Domain/Repositories/userList_repository.dart';
import 'package:one/Domain/models/userList_model.dart';
import 'package:one/Infrastructure/data_providers/userList_api.dart';
import 'package:riverpod/riverpod.dart';

final userListRepositoryProvider = Provider<userListRepository>((ref) {
  return UserListRepositoryImpl();
});

class UserListRepositoryImpl implements userListRepository {
  @override
  Future<void> updateRole(userList userList) async {
    if (userList.id == null) {
      throw Exception('User ID is required for update');
    }
    await userListApi.updateRole(userList.id!, userList); 
    print(userList);
  }

  @override
  Future<List<userList>> fetchUserList() async {
    return await userListApi.fetchUserList();
  }
}
