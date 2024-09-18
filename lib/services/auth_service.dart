import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in to Firebase
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      print('Failed with error code: ${e.code}');
      print(e.message);
      return null;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successful sign-in, retrieve user role from Firestore
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userRoleDoc = await FirebaseFirestore.instance
            .collection('user_roles')
            .doc(user.uid)
            .get();
        Map<String, dynamic>? userData = userRoleDoc.data()
            as Map<String, dynamic>?; // Cast to Map<String, dynamic>

        if (userData != null) {
          String role = userData['role'] ?? 'patient'; // Use subscript notation
          print('User role: $role');
        }
      }

      return userCredential;
    } catch (e) {
      print('Sign-in error: $e');
      return null;
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      print("insidesignup");
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      print('Failed with error code: ${e.code}');
      print(e.message);
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut(); // Sign out from Google as well
  }

  // Get the currently signed-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Stream of user changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
