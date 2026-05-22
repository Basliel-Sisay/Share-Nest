import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import 'auth_provider.dart';

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final userRoleProvider = Provider<UserRole?>((ref) {
  return ref.watch(currentUserProvider)?.role;
});

final isResourceOwnerProvider = Provider<bool>((ref) {
  return ref.watch(userRoleProvider) == UserRole.resourceOwner;
});

final canApproveRequestsProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.canApproveRequests() ?? false;
});

final canCreateResourceProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.canCreateResource() ?? false;
});
