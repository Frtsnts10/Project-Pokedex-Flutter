import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth? _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  static bool _isInitialized = false;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _firebaseAuth = firebaseAuth ??
            (Firebase.apps.isNotEmpty ? FirebaseAuth.instance : null);

  Future<User?> signInWithGoogle() async {
    if (_firebaseAuth == null) {
      print('Firebase not initialized. Cannot sign in.');
      return null;
    }
    try {
      if (!_isInitialized) {
        await _googleSignIn.initialize();
        _isInitialized = true;
      }

      final GoogleSignInAccount account = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = account.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken:
            null, // Access token is separated in v7, often not needed for Firebase with just OpenID
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth!.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      if (e is GoogleSignInException &&
          e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth?.signOut();
  }

  Stream<User?> get authStateChanges =>
      _firebaseAuth?.authStateChanges() ?? Stream.value(null);
}
