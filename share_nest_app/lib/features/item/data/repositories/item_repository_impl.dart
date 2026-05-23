import '../../domain/entities/item.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasource/item_local_datasource.dart';
import '../datasource/item_remote_datasource.dart';
import '../mappers/item_mapper.dart';

/// Cache-first repository: SQLite → (if empty/stale) Dio → SQLite → return.
class ItemRepositoryImpl implements ItemRepository {
  final ItemRemoteDataSource _remoteDataSource;
  final ItemLocalDataSource _localDataSource;

  ItemRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Item>> fetchItems({bool forceRefresh = false}) async {
    final cacheEmpty = await _localDataSource.isCacheEmpty();
    final cacheStale = await _localDataSource.isCacheStale();

    if (!forceRefresh && !cacheEmpty && !cacheStale) {
      final cached = await _localDataSource.getCachedItems();
      return ItemMapper.toEntityList(cached);
    }

    try {
      final remote = await _remoteDataSource.fetchItems();
      await _localDataSource.cacheItems(remote);
      return ItemMapper.toEntityList(remote);
    } catch (_) {
      final cached = await _localDataSource.getCachedItems();
      if (cached.isNotEmpty) {
        return ItemMapper.toEntityList(cached);
      }
      rethrow;
    }
  }
}
