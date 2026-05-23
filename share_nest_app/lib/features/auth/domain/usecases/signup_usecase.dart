import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _repository;

  SignupUseCase(this._repository);

  Future<User> execute(String name, String email, String password) {
    return _repository.signup(name, email, password);
  }
}
