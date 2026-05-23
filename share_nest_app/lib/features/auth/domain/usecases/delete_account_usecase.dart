import '../repositories/auth_repository.dart';

class DeleteAccountUseCase {
  final AuthRepository _repository;

  DeleteAccountUseCase(this._repository);

  Future<void> execute() {
    return _repository.deleteAccount();
  }
}
