import '../datasources/resource_local_datasource.dart';
import '../datasources/resource_remote_datasource.dart';
import '../datasources/seed_data.dart';
import '../models/resource_item.dart';

class ResourceRepository {
  ResourceRepository({
    required ResourceLocalDataSource local,
    required ResourceRemoteDataSource remote,
  })  : _local = local,
        _remote = remote;

  final ResourceLocalDataSource _local;
  final ResourceRemoteDataSource _remote;

  /// Cache-first: returns SQLite data when present; otherwise fetches Node API.
  Future<List<ResourceItem>> getResources({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _local.getAll();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final remote = await _remote.fetchAll();
      for (final item in remote) {
        await _local.insert(item);
      }
      return _local.getAll();
    } catch (_) {
      final fallback = SeedData.resources();
      await _local.insertAll(fallback);
      return fallback;
    }
  }

  Future<ResourceItem?> getResourceById(String id) async {
    final cached = await _local.getById(id);
    if (cached != null) return cached;

    try {
      final remote = await _remote.fetchById(id);
      if (remote != null) {
        await _local.insert(remote);
      }
      return remote;
    } catch (_) {
      for (final item in SeedData.resources()) {
        if (item.id == id) {
          await _local.insert(item);
          return item;
        }
      }
      return null;
    }
  }

  Future<ResourceItem> addResource(ResourceItem item) async {
    try {
      final saved = await _remote.syncResource(item);
      await _local.insert(saved);
      return saved;
    } catch (_) {
      await _local.insert(item);
      return item;
    }
  }

  Future<List<ResourceItem>> refreshFromNetwork() async {
    return getResources(forceRefresh: true);
  }
}
