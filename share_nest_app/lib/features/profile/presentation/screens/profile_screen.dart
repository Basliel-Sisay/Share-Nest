import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all associated data. Are you sure?',
        ),
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
    await ref.read(authProvider.notifier).deleteAccount();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final resourcesAsync = ref.watch(resourcesProvider);
    final loansAsync = ref.watch(loansProvider);

    final resourceCount = resourcesAsync.asData?.value.length ?? 0;
    final loanCount = loansAsync.asData?.value.length ?? 0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 10),
              Text(
                user?.name ?? "User",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(user?.email ?? ""),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatBox(title: "Resources", value: "$resourceCount"),
                  _StatBox(title: "Loans", value: "$loanCount"),
                ],
              ),
              const SizedBox(height: 30),
              _menuItem(
                icon: Icons.settings,
                title: "Settings",
                onTap: () => context.push('/settings'),
              ),
              _menuItem(
                icon: Icons.history,
                title: "Sharing History",
                onTap: () => context.push('/history'),
              ),
              _menuItem(icon: Icons.help, title: "Help Center", onTap: () {}),
              const SizedBox(height: 20),
              if (authState.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              if (authState.error != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    authState.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                onPressed: authState.isLoading ? null : () => _deleteAccount(context, ref),
                child: const Text(
                  "Delete Account",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(title),
        ],
      ),
    );
  }
}
