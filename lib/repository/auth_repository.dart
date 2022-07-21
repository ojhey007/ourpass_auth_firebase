import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:ourpass/models/user_model.dart';

class AuthRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  AuthRepository();

  User? userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.email, user.emailVerified);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map((userFromFirebase));
  }

// signup method

  Future<dynamic> signUp(
      {required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      return (e.message);
    }
  }

// method to sign in with email and password

  Future<dynamic> signIn(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      return (e.message);
    }
  }

// method for email verification
  Future<dynamic> verifyEmail() async {
    try {
      final user = auth.FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } on auth.FirebaseAuthException catch (e) {
      return (e.message);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
