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
    setState(() {
      _loading = true;
    });
    try {
      final api = ref.read(apiClientProvider);
      final users = await AdminRemoteDataSource(client: api).fetchUsers();
      setState(() {
        _users = users;
      });
    } catch (_) {

    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _changeRole(String userId, String currentRole) async {
    String newRole;
    if (currentRole == 'admin') {
      newRole = 'user';
    } else {
      newRole = 'admin';
    }
    try {
      final api = ref.read(apiClientProvider);
      await AdminRemoteDataSource(client: api).updateUserRole(userId, newRole);
      await _loadUsers();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Role changed to $newRole')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }

  Future<void> _deleteUser(String userId, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text('Delete user "$name" and all their data?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }

    try {
      final api = ref.read(apiClientProvider);
      await AdminRemoteDataSource(client: api).deleteUser(userId);
      await _loadUsers();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_loading) {
      content = const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(16, 185, 129, 1)),
        ),
      );
    } else {
      content = RefreshIndicator(
        onRefresh: _loadUsers,
        color: const Color.fromRGBO(16, 185, 129, 1),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 12,
            left: 20,
            right: 20,
          ),
          itemCount: _users.length,
          itemBuilder: (_, i) {
            final user = _users[i];
            
            Color avatarColor;
            IconData roleIcon;
            if (user['role'] == 'admin') {
              avatarColor = const Color.fromRGBO(245, 158, 11, 1);
              roleIcon = Icons.shield;
            } else {
              avatarColor = const Color.fromRGBO(148, 163, 184, 1);
              roleIcon = Icons.person_outline;
            }

            return Container(
              margin: const EdgeInsets.only(
                bottom: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromRGBO(226, 232, 240, 1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 16,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: avatarColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: avatarColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(15, 41, 66, 1),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user['email'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(100, 116, 139, 1),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.only(
                              top: 2,
                              bottom: 2,
                              left: 8,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                              color: avatarColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (user['role'] as String).toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: avatarColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            roleIcon,
                            color: const Color.fromRGBO(16, 185, 129, 1),
                            size: 22,
                          ),
                          onPressed: () {
                            _changeRole(user['id'] as String, user['role'] as String);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Color.fromRGBO(239, 68, 68, 1),
                            size: 22,
                          ),
                          onPressed: () {
                            _deleteUser(user['id'] as String, user['name'] as String);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 247, 254, 1),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'User Management',
          style: TextStyle(
            color: Color.fromRGBO(5, 2, 24, 1),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 8,
            right: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color.fromRGBO(15, 41, 66, 1),
              size: 16,
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(90, 255, 98, 1),
                    Color.fromRGBO(244, 247, 250, 0.1),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: content,
          ),
        ],
      ),
    );
  }
}
