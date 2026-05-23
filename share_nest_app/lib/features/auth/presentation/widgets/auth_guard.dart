import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../providers/role_provider.dart';

class RoleGuard extends ConsumerWidget {
  final Widget child;
  final List<UserRole> allowedRoles;
  final Widget? fallback;

  const RoleGuard({
    super.key,
    required this.child,
    required this.allowedRoles,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(userRoleProvider);

    if (role != null && allowedRoles.contains(role)) {
      return child;
    }

    return fallback ??
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'You do not have permission to access this content.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
  }
}

class ResourceOwnerGuard extends ConsumerWidget {
  final Widget child;
  final Widget? fallback;

  const ResourceOwnerGuard({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwner = ref.watch(isResourceOwnerProvider);

    if (isOwner) {
      return child;
    }

    return fallback ??
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Only resource owners can perform this action.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
  }
}
