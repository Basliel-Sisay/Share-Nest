import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_helper.dart';
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

final databaseHelperProvider = Provider<DatabaseHelper>(
  (ref) => DatabaseHelper.instance,
);

final resourceRepositoryProvider = Provider<ResourceRepository>((ref) {
  final db = ref.watch(databaseHelperProvider);
  return ResourceRepository(
    local: ResourceLocalDataSource(db),
    remote: ResourceRemoteDataSource(),
  );
});

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  final db = ref.watch(databaseHelperProvider);
  return LoanRepository(
    local: LoanLocalDataSource(db),
    remote: LoanRemoteDataSource(),
  );
});

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  final db = ref.watch(databaseHelperProvider);
  return ReservationRepository(
    local: ReservationLocalDataSource(db),
    remote: ReservationRemoteDataSource(),
  );
});

class ResourcesNotifier extends AsyncNotifier<List<ResourceItem>> {
  @override
  Future<List<ResourceItem>> build() async {
    final repo = ref.read(resourceRepositoryProvider);
    return repo.getResources();
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
    return ref.read(loanRepositoryProvider).getLoans();
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
    return ref.read(reservationRepositoryProvider).getReservations();
  }

  Future<void> addReservation(ReservationItem item) async {
    final repo = ref.read(reservationRepositoryProvider);
    await repo.createReservation(item);
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

class HomeSearchNotifier extends Notifier<String> {
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

class ReservationDraft {
  const ReservationDraft({
    required this.resourceId,
    required this.resourceTitle,
  });

  final String resourceId;
  final String resourceTitle;
}

class ReservationDraftNotifier extends Notifier<ReservationDraft?> {
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
