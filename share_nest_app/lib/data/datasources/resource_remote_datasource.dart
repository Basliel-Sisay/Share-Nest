import '../../core/network/api_client.dart';
import '../models/resource_item.dart';

/// Fetches resources from the Node.js API (server SQLite).
class ResourceRemoteDataSource {
  ResourceRemoteDataSource({ApiClient? client})
      : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<ResourceItem>> fetchAll() async {
    final rows = await _client.getList('/api/resources');
    return rows.map(ResourceItem.fromMap).toList();
  }

  Future<ResourceItem?> fetchById(String id) async {
    try {
      final row = await _client.getOne('/api/resources/$id');
      return ResourceItem.fromMap(row);
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<ResourceItem> syncResource(ResourceItem item) async {
    final row = await _client.post('/api/resources', item.toMap());
    return ResourceItem.fromMap(row);
  }
}
