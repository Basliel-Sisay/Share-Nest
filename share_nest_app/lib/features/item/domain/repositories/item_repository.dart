import '../entities/item.dart';

abstract class ItemRepository {
  /// Cache-first: reads SQLite; if empty or stale, fetches via Dio and persists.
  Future<List<Item>> fetchItems({bool forceRefresh = false});
}
