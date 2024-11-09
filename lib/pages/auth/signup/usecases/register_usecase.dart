import 'package:ctree/pages/auth/data/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<void> execute(
      String email, String password, String displayName, String role) {
    return authRepository.register(email, password, displayName, role);
  }
}
