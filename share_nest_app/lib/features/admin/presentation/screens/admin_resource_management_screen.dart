import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../data/models/resource_item.dart';
import '../../data/datasources/admin_remote_datasource.dart';

class AdminResourceManagementScreen extends ConsumerStatefulWidget {
  const AdminResourceManagementScreen({super.key});

  @override
  ConsumerState<AdminResourceManagementScreen> createState() => _AdminResourceManagementScreenState();
}

class _AdminResourceManagementScreenState extends ConsumerState<AdminResourceManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final resourcesAsync = ref.watch(resourcesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text('All Resources', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: resourcesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (resources) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: resources.length,
          itemBuilder: (_, i) {
            final r = resources[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(child: Icon(r.category == 'Books' ? Icons.book : Icons.build)),
                title: Text(r.title),
                subtitle: Text('${r.ownerName} | ${r.isAvailable ? "Available" : "Unavailable"}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => context.push('/edit-resource/${r.id}'),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _adminDeleteResource(r),
                      tooltip: 'Delete (admin)',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _adminDeleteResource(ResourceItem resource) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Admin: Delete Resource'),
        content: Text('Delete "${resource.title}" as admin?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final api = ref.read(apiClientProvider);
      await AdminRemoteDataSource(client: api).deleteResource(resource.id);
      await ref.read(resourcesProvider.notifier).refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resource deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }
}
