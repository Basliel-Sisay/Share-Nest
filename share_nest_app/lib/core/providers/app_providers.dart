import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../database/database_helper.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../data/datasources/loan_local_datasource.dart';
import '../../data/datasources/loan_remote_datasource.dart';
import '../../data/datasources/reservation_local_datasource.dart';
import '../../data/datasources/reservation_remote_datasource.dart';
import '../../data/datasources/resource_local_datasource.dart';
import '../../data/datasources/resource_remote_datasource.dart';
import '../../data/models/loan_item.dart';
import '../../data/models/reservation_item.dart';
import '../../data/models/resource_item.dart';
import '../../data/repositories/loan_repository.dart';
import '../../data/repositories/reservation_repository.dart';
import '../../data/repositories/resource_repository.dart';

export '../../features/auth/presentation/controllers/auth_controller.dart';

class SettingsNotifier extends Notifier<bool> {
  static const _key = 'notifyNewProducts';
  late SharedPreferences _prefs;

  @override
  bool build() {
    _init();
    return false;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    state = _prefs.getBool(_key) ?? false;
  }

  Future<void> toggleNotification(bool value) async {
    state = value;
    await _prefs.setBool(_key, value);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, bool>(SettingsNotifier.new);

final apiClientProvider = Provider<ApiClient>((ref) {
  final authState = ref.watch(authProvider);
  final token = authState.user?.token;
  if (token != null) return ApiClient(authToken: token);
  return ApiClient();
});

final resourceRepositoryProvider = Provider<ResourceRepository>((ref) {
  final db = ref.watch(databaseHelperProvider);
  final client = ref.watch(apiClientProvider);
  return ResourceRepository(
    local: ResourceLocalDataSource(db),
    remote: ResourceRemoteDataSource(client: client),
  );
});

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  final db = ref.watch(databaseHelperProvider);
  final client = ref.watch(apiClientProvider);
  return LoanRepository(
    local: LoanLocalDataSource(db),
    remote: LoanRemoteDataSource(client: client),
  );
});

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  final db = ref.watch(databaseHelperProvider);
  final client = ref.watch(apiClientProvider);
  return ReservationRepository(
    local: ReservationLocalDataSource(db),
    remote: ReservationRemoteDataSource(client: client),
  );
});

class ResourcesNotifier extends AsyncNotifier<List<ResourceItem>> {
  @override
  Future<List<ResourceItem>> build() async {
    final repo = ref.watch(resourceRepositoryProvider);
    return repo.refreshFromNetwork();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(resourceRepositoryProvider);
      await repo.refreshFromNetwork();
      return repo.getResources(forceRefresh: true);
    });
  }

  Future<void> addResource(ResourceItem item) async {
    final repo = ref.read(resourceRepositoryProvider);
    await repo.addResource(item);
    state = await AsyncValue.guard(() => repo.getResources());
  }

  Future<void> updateResource(ResourceItem item) async {
    final repo = ref.read(resourceRepositoryProvider);
    await repo.updateResource(item);
    state = await AsyncValue.guard(() => repo.getResources());
  }

  Future<void> deleteResource(String id) async {
    final repo = ref.read(resourceRepositoryProvider);
    await repo.deleteResource(id);
    state = await AsyncValue.guard(() => repo.getResources());
  }
}

final resourcesProvider =
    AsyncNotifierProvider<ResourcesNotifier, List<ResourceItem>>(
  ResourcesNotifier.new,
);

final resourceByIdProvider =
    FutureProvider.family<ResourceItem?, String>((ref, id) async {
  final repo = ref.watch(resourceRepositoryProvider);
  return repo.getResourceById(id);
});

class LoansNotifier extends AsyncNotifier<List<LoanItem>> {
  @override
  Future<List<LoanItem>> build() async {
    return ref.watch(loanRepositoryProvider).getLoans();
  }

  Future<void> requestLoan(Map<String, dynamic> data) async {
    final repo = ref.read(loanRepositoryProvider);
    await repo.requestLoan(data);
    state = await AsyncValue.guard(() => repo.getLoans());
  }

  Future<void> updateLoanStatus(String loanId, String status) async {
    final repo = ref.read(loanRepositoryProvider);
    await repo.updateLoanStatus(loanId, status);
    state = await AsyncValue.guard(() => repo.getLoans());
  }

  Future<void> extendLoan(String loanId, DateTime newDate) async {
    final repo = ref.read(loanRepositoryProvider);
    await repo.extendLoan(loanId, newDate);
    state = await AsyncValue.guard(() => repo.getLoans());
  }
}

final loansProvider =
    AsyncNotifierProvider<LoansNotifier, List<LoanItem>>(LoansNotifier.new);

class ReservationsNotifier extends AsyncNotifier<List<ReservationItem>> {
  @override
  Future<List<ReservationItem>> build() async {
    return ref.watch(reservationRepositoryProvider).getReservations();
  }

  Future<void> addReservation(ReservationItem item) async {
    final repo = ref.read(reservationRepositoryProvider);
    await repo.createReservation(item);
    state = await AsyncValue.guard(() => repo.getReservations());
  }

  Future<void> updateReservation(ReservationItem item) async {
    final repo = ref.read(reservationRepositoryProvider);
    await repo.updateReservation(item);
    state = await AsyncValue.guard(() => repo.getReservations());
  }

  Future<void> deleteReservation(String id) async {
    final repo = ref.read(reservationRepositoryProvider);
    await repo.deleteReservation(id);
    state = await AsyncValue.guard(() => repo.getReservations());
  }
}

final reservationsProvider =
    AsyncNotifierProvider<ReservationsNotifier, List<ReservationItem>>(
  ReservationsNotifier.new,
);

class BrowseSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String q) => state = q;
}

final browseSearchProvider =
    NotifierProvider<BrowseSearchNotifier, String>(BrowseSearchNotifier.new);

class BrowseCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All Resources';

  void setCategory(String c) => state = c;
}

final browseCategoryProvider = NotifierProvider<BrowseCategoryNotifier, String>(
  BrowseCategoryNotifier.new,
);

class HomeSearchNotifier extends Notifier<String>{
  @override
  String build() => '';

  void setQuery(String q) => state = q;
}

final homeSearchProvider =
    NotifierProvider<HomeSearchNotifier, String>(HomeSearchNotifier.new);

final reservationDraftProvider =
    NotifierProvider<ReservationDraftNotifier, ReservationDraft?>(
  ReservationDraftNotifier.new,
);

class ReservationDraft{
  const ReservationDraft({
    required this.resourceId,
    required this.resourceTitle,
  });

  final String resourceId;
  final String resourceTitle;
}

class ReservationDraftNotifier extends Notifier<ReservationDraft?>{
  @override
  ReservationDraft? build() => null;

  void setDraft(ReservationDraft? draft) => state = draft;

  void clear() => state = null;
}

List<ResourceItem> filterResources(
  List<ResourceItem> items, {
  required String query,
  required String category,
  bool availableOnly = true,
}) {
  var result = items;
  if (availableOnly) {
    result = result.where((r) => r.isAvailable).toList();
  }
  if (category != 'All Resources') {
    result = result.where((r) => r.category == category).toList();
  }
  if (query.trim().isNotEmpty) {
    final q = query.trim().toLowerCase();
    result = result
        .where(
          (r) =>
              r.title.toLowerCase().contains(q) ||
              r.description.toLowerCase().contains(q) ||
              r.ownerName.toLowerCase().contains(q) ||
              r.category.toLowerCase().contains(q),
        )
        .toList();
  }
  return result;
}

String slugifyTitle(String title) {
  return title
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}
