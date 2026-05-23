import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isOwner = ref.watch(isResourceOwnerProvider);

    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    user.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(user.name,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(user.email,
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOwner
                        ? Colors.amber.withOpacity(0.15)
                        : Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isOwner
                          ? Colors.amber
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOwner ? Icons.inventory_2 : Icons.person,
                        size: 16,
                        color: isOwner
                            ? Colors.amber[700]
                            : Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        user.role.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isOwner
                              ? Colors.amber[700]
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          Text('Your Permissions',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                    letterSpacing: 1,
                  )),
          const SizedBox(height: 8),
          _PermissionTile(
              icon: Icons.search,
              label: 'Browse & search resources',
              granted: true),
          _PermissionTile(
              icon: Icons.request_page,
              label: 'Submit loan requests',
              granted: true),
          _PermissionTile(
              icon: Icons.calendar_month,
              label: 'Make reservations',
              granted: true),
          _PermissionTile(
              icon: Icons.add_box,
              label: 'List resources for sharing',
              granted: isOwner),
          _PermissionTile(
              icon: Icons.check_circle,
              label: 'Approve / reject loan requests',
              granted: isOwner),
          _PermissionTile(
              icon: Icons.event_available,
              label: 'Manage reservation approvals',
              granted: isOwner),

          const SizedBox(height: 40),

          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context, ref),
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => _confirmDeleteAccount(context, ref),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Sign Out')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).logout();
    }
  }

  Future<void> _confirmDeleteAccount(
      BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'This is permanent. All your resources, loans, and reservations will be deleted.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).deleteAccount();
    }
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.label,
    required this.granted,
  });

  final IconData icon;
  final String label;
  final bool granted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(granted ? Icons.check_circle : Icons.cancel,
              size: 18, color: granted ? Colors.green : Colors.grey[400]),
          const SizedBox(width: 12),
          Icon(icon, size: 18, color: granted ? null : Colors.grey[400]),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(color: granted ? null : Colors.grey[400])),
        ],
      ),
    );
  }
}