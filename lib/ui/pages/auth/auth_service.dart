import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credentials.user;
    } on FirebaseAuthException catch (e) {
      log("Sign Up Error: ${e.code}: ${e.message}");
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('User logged in: ${credentials.user?.email}'); // Debug output
      return credentials.user; // Returns the User object if successful
    } on FirebaseAuthException catch (e) {
      log("Login Error: ${e.code}: ${e.message}");
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null; // Handle errors by returning null
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Sign Out Error: $e");
    }
  }
}
