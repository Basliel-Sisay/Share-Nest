import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasource/item_local_datasource.dart';
import '../../data/datasource/item_remote_datasource.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/item_repository.dart';

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final db = ref.watch(appDatabaseProvider);
  return ItemRepositoryImpl(
    ItemRemoteDataSource(dio),
    ItemLocalDataSource(db),
  );
});

final itemsProvider = FutureProvider<List<Item>>((ref) async {
  final repo = ref.watch(itemRepositoryProvider);
  return repo.fetchItems();
});
