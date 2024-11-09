import 'package:ctree/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static UserModel? _currentUserModel;

  AuthRepository(this._firebaseAuth);

  static UserModel? get currentUserModel => _currentUserModel;

  Future<void> register(
      String email, String password, String displayName, String role) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    await _firebaseAuth.currentUser?.sendEmailVerification();

    if (user != null) {
      final userModel = UserModel(
        displayName: displayName,
        role: role,
        uuid: user.uid,
      );
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      _currentUserModel = userModel;
    }
  }

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        _currentUserModel = UserModel.fromMap(doc.data()!, user.uid);
      }
    }
  }

  Future<UserModel?> getCurrentUserModel() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        _currentUserModel = UserModel.fromMap(doc.data()!, user.uid);
        return _currentUserModel;
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _currentUserModel = null;
  }

  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      _currentUserModel = null;
    }
  }
}
