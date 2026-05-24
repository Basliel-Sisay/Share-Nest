import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../data/datasources/admin_remote_datasource.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    try {
      final api = ref.read(apiClientProvider);
      final users = await AdminRemoteDataSource(client: api).fetchUsers();
      setState(() => _users = users);
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _changeRole(String userId, String currentRole) async {
    final newRole = currentRole == 'admin' ? 'user' : 'admin';
    try {
      final api = ref.read(apiClientProvider);
      await AdminRemoteDataSource(client: api).updateUserRole(userId, newRole);
      await _loadUsers();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Role changed to $newRole')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }

  Future<void> _deleteUser(String userId, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Delete user "$name" and all their data?'),
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
      await AdminRemoteDataSource(client: api).deleteUser(userId);
      await _loadUsers();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text('User Management', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _users.length,
                itemBuilder: (_, i) {
                  final user = _users[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: user['role'] == 'admin' ? Colors.amber : Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(user['name'] as String),
                      subtitle: Text('${user['email']}  |  ${user['role']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              user['role'] == 'admin' ? Icons.shield : Icons.person_outline,
                              color: Colors.blue,
                            ),
                            onPressed: () => _changeRole(user['id'] as String, user['role'] as String),
                            tooltip: 'Toggle role',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user['id'] as String, user['name'] as String),
                            tooltip: 'Delete user',
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
}
