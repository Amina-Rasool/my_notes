import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Abhi ye gray hai

class FirebaseAuthRepositoryImpl {
  // 1. FirebaseAuth.instance likhne se 'firebase_auth' active ho jayega
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      // 2. Sahi bracket aur variable name check karein
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.message}");
      return null;
    }
  }
}