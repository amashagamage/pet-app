import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String name}) async {
    try {
      // Validate input fields
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return "Please fill in all fields";
      }

      // Validate email format
      if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email)) {
        return "Please enter a valid email address";
      }

      // Validate password strength
      if (password.length < 6) {
        return "Password must be at least 6 characters long";
      }

      // Create user with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _firebaseFirestore
          .collection("users")
          .doc(credential.user!.uid)
          .set({
        "name": name,
        "email": email,
        "uid": credential.user!.uid,
        "isAdmin": false,
        "isUser": true,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return "This email is already registered. Please use a different email or login.";
        case 'invalid-email':
          return "Invalid email address format.";
        case 'operation-not-allowed':
          return "Email/password accounts are not enabled. Please contact support.";
        case 'weak-password':
          return "Password is too weak. Please use a stronger password.";
        default:
          return "Authentication error: ${e.message}";
      }
    } on FirebaseException catch (e) {
      return "Firebase error: ${e.message}";
    } catch (e) {
      return "An unexpected error occurred: ${e.toString()}";
    }
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occurred";
    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please fill in all fields";
      }

      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userSnapshot = await _firebaseFirestore
          .collection("users")
          .doc(cred.user!.uid)
          .get();

      bool isAdmin = userSnapshot['isAdmin'] ?? false;
      if (isAdmin) {
        res = "admin";
      } else {
        res = "user";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return "No user found with this email.";
        case 'wrong-password':
          return "Wrong password provided.";
        case 'invalid-email':
          return "Invalid email address format.";
        case 'user-disabled':
          return "This account has been disabled.";
        default:
          return "Authentication error: ${e.message}";
      }
    } catch (e) {
      return "An unexpected error occurred: ${e.toString()}";
    }
    return res;
  }

  Future<void> signout() async {
    await _auth.signOut();
  }
}
