import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/Domain/Repositories/userList_repository.dart';
import 'package:one/Domain/models/userList_model.dart';
import 'package:one/Infrastructure/repositories/userList_repository_impl.dart';

// Notifier class
class UserListNotifier extends StateNotifier<AsyncValue<List<userList>>> {
  final userListRepository _repository;

  UserListNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> fetchUserList() async {
    state = const AsyncValue.loading();
    try {
      final userLists = await _repository.fetchUserList();
      state = AsyncValue.data(userLists);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> updateRole(String id, userList updatedUser) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateRole(updatedUser);
      final userLists = await _repository.fetchUserList();
      state = AsyncValue.data(userLists);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }
}

// Repository provider
final userListRepositoryProvider = Provider<userListRepository>((ref) {
  return UserListRepositoryImpl(); 
});

// Notifier provider
final userListNotifierProvider = StateNotifierProvider<UserListNotifier, AsyncValue<List<userList>>>((ref) {
  final repository = ref.watch(userListRepositoryProvider);
  return UserListNotifier(repository);
});
