import '../../../../core/constants/api_constants.dart';
import '../../../../core/database/app_database.dart';
import '../models/item_dto.dart';

class ItemLocalDataSource {
  final AppDatabase _database;

  ItemLocalDataSource(this._database);

  Future<List<ItemDto>> getCachedItems() async {
    final rows = await _database.getAllItems();
    return rows.map(ItemDto.fromDb).toList();
  }

  Future<void> cacheItems(List<ItemDto> items) async {
    final now = DateTime.now();
    final rows = items.map((dto) => dto.toDb(cachedAt: now)).toList();
    await _database.replaceAllItems(rows);
    await _database.setCacheUpdatedAt(ApiConstants.itemsCacheKey, now);
  }

  Future<bool> isCacheEmpty() async {
    final items = await getCachedItems();
    return items.isEmpty;
  }

  Future<bool> isCacheStale() async {
    final updatedAt = await _database.getCacheUpdatedAt(
      ApiConstants.itemsCacheKey,
    );
    if (updatedAt == null) return true;
    return DateTime.now().difference(updatedAt) >
        ApiConstants.cacheStaleDuration;
  }
}
