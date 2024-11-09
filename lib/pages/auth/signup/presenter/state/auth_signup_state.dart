import 'package:ctree/core/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ctree/pages/auth/data/auth_repository.dart';

class AuthSignupState with ChangeNotifier {
  final AuthRepository _authRepository;
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthSignupState(this._authRepository);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> register(
      String email, String password, String displayName, String role) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.register(email, password, displayName, role);

      _user = AuthRepository.currentUserModel!;
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _user = null;
    notifyListeners();
  }
}
