import 'package:firebase_auth/firebase_auth.dart' as auth;
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

  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Signed up";
    } on auth.FirebaseAuthException catch (e) {
      print("Hmmm${e.message}");
      return (e.message);
    }
  }

  Future<dynamic> signIn(
      {required String email, required String password}) async {
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

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
