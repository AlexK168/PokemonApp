import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../entities/user.dart';
import '../exceptions.dart';


class AuthenticationRepository {
  User? _cachedUser;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  AuthenticationRepository();

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cachedUser = user;
      return user;
    });
  }

  User get currentUser {
    return _cachedUser ?? User.empty;
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {
      throw Failure.signUpError;
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw e.toFailure;
    } catch (_) {
      throw Failure.loginError;
    }
  }

  Future<void> logOut() async {
    // throw Failure.logoutError;
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {
      throw Failure.logoutError;
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email);
  }
}

extension on firebase_auth.FirebaseAuthException {
  Failure get toFailure {
    switch (code) {
      case 'invalid-email':
        return Failure.invalidEmail;
      case 'user-disabled':
        return Failure.userDisabled;
      case 'user-not-found':
        return Failure.userNotFound;
      case 'wrong-password':
        return Failure.wrongPassword;
      default:
        return Failure.unknownError;
    }
  }
}
