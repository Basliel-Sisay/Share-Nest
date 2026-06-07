import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepository{
  AuthRepository({
    required AuthLocalDataSource local,
    required AuthRemoteDataSource remote,
  })  : _local = local,
        _remote = remote;

  final AuthLocalDataSource _local;
  final AuthRemoteDataSource _remote;

  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await _remote.signup(
      name: name,
      email: email,
      password: password,
    );
    final user = result.user.copyWith(token: result.token);
    await _local.saveUser(user);
    return user;
  }

  Future<UserModel> login({required String email,required String password}) async{
    final result = await _remote.login(
      email: email,
      password: password,
    );
    final user = result.user.copyWith(token: result.token);
    await _local.saveUser(user);
    return user;
  }

  Future<UserModel?> tryAutoLogin() async{
    final cached = await _local.getUser();
    if (cached == null || cached.token == null) return null;

    try {
      final fresh = await _remote.fetchMe(cached.token!);
      // Merge new remote data with cached imagePath
      final user = fresh.copyWith(token: cached.token, imagePath: cached.imagePath);
      await _local.saveUser(user);
      return user;
    } 
    catch (_) {
      return cached;
    }
  }

  Future<void> deleteAccount() async{
    final cached = await _local.getUser();
    if (cached?.token != null){
      try {
        await _remote.deleteAccount(cached!.token!);
      } catch (_) {}
    }
    await _local.deleteUser();
  }

  Future<void> updateProfileImage(String userId, String imagePath) async {
    final cached = await _local.getUser();
    if (cached != null && cached.id == userId) {
      final updatedUser = cached.copyWith(imagePath: imagePath);
      await _local.saveUser(updatedUser);
    }
  }

  Future<void> logout() async{
    await _local.deleteUser();
  }
}
