import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/Domain/Repositories/userList_repository.dart';
import 'package:one/Domain/models/userList_model.dart';
import 'package:one/infrastructure/repositories/userList_repository_impl.dart';

final userListRepositoryProvider = Provider<UserListRepository>((ref) {
  return UserListRepositoryImpl();
});

class UserListNotifier extends StateNotifier<AsyncValue<List<userList>>> {
  final UserListRepository _repository;

  UserListNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchUserList();
  }

  Future<void> fetchUserList() async {
    state = const AsyncValue.loading();
    try {
      final userLists = await _repository.fetchUserList();
      state = AsyncValue.data(userLists);
    } catch (e) {
      print('Error fetching user lists: $e');
      state = AsyncValue.error(e);
    }
  }

  Future<void> updateRole(userList updatedUser) async {
    try {
      await _repository.updateRole(updatedUser);
      final userLists = await _repository.fetchUserList();
      state = AsyncValue.data(userLists);
    } catch (e) {
      print('Error updating user role: $e');
      state = AsyncValue.error(e);
    }
  }
}

final userListNotifierProvider = StateNotifierProvider<UserListNotifier, AsyncValue<List<userList>>>((ref) {
  final repository = ref.watch(userListRepositoryProvider);
  return UserListNotifier(repository);
});
