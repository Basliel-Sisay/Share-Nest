import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_model.dart';
import '../providers/auth_notifier.dart';

class RoleGuard extends ConsumerWidget {
  const RoleGuard({
    super.key,
    required this.requiredRole,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  }) : builder = null;

  const RoleGuard.builder({
    super.key,
    required Widget Function(BuildContext, UserRole) builder,
  })  : requiredRole = null,
        child = const SizedBox.shrink(),
        fallback = const SizedBox.shrink(),
        builder = builder;

  final UserRole? requiredRole;
  final Widget child;
  final Widget fallback;
  final Widget Function(BuildContext, UserRole)? builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentUserRoleProvider);

    if (builder != null) {
      return builder!(context, role);
    }

    if (requiredRole == null || role == requiredRole) {
      return child;
    }

    return fallback;
  }
}

class OwnerOnly extends ConsumerWidget {
  const OwnerOnly({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwner = ref.watch(isResourceOwnerProvider);
    return isOwner ? child : const SizedBox.shrink();
  }
}

class BorrowerOnly extends ConsumerWidget {
  const BorrowerOnly({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwner = ref.watch(isResourceOwnerProvider);
    return !isOwner ? child : const SizedBox.shrink();
  }
}