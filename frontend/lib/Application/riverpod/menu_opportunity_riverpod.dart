import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/Domain/Repositories/menuOpportunity_repository.dart';
import 'package:one/Domain/models/menu_opportunity_model.dart';
import 'package:one/Infrastructure/repositories/menuOpportunity_repository_impl.dart';


// State Notifier to manage Menu Opportunity state
class MenuOpportunityNotifier extends StateNotifier<AsyncValue<List<MenuOpportunity>>> {
  final MenuOpportunityRepository repository;

  MenuOpportunityNotifier(this.repository) : super(AsyncValue.loading()) {
    _fetchOpportunities();
  }

  // Fetch menu opportunities from repository
  Future<void> _fetchOpportunities() async {
    try {
      final menuOpportunities = await repository.fetchOpportunity();
      state = AsyncValue.data(menuOpportunities);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  // Register a menu opportunity
  Future<void> registerOpportunity(MenuOpportunity menuOpportunity) async {
    try {
      await repository.registerOpportunity(menuOpportunity);
      _fetchOpportunities(); // Refresh the list after registration
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }
}

// Provider for MenuOpportunityNotifier
final menuOpportunityNotifierProvider = StateNotifierProvider<MenuOpportunityNotifier, AsyncValue<List<MenuOpportunity>>>((ref) {
  final repository = MenuOpportunityRepositoryImpl(); // You can replace with dependency injection if preferred
  return MenuOpportunityNotifier(repository);
});
