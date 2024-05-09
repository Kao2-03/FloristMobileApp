import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Kiểm tra xem email có tồn tại trong Firebase Authentication không.
  Future<bool> checkEmailExists(String email) async {
    try {
      var userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: "temporaryPassword");
      if (userCredential != null) {
        await userCredential.user!.delete();
        return true;
      }
      return false;
    } catch (error) {
      if (error is FirebaseAuthException && error.code == 'email alreadyinuse') {
        return true;
      }
      print("Lỗi kiểm tra email: $error");
      return false;
    }
  }

  // Đăng nhập bằng email và mật khẩu.
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (error) {
      print("Lỗi đăng nhập bằng email và password: $error");
      throw error;
    }
  }

  // Đăng nhập bằng Google.
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
      return null;
    } catch (error) {
      print("Lỗi đăng nhập bằng Google: $error");
      throw error;
    }
  }

  // Đăng nhập bằng Facebook.
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
      final UserCredential userCredential = await _auth.signInWithCredential(facebookAuthCredential);
      return userCredential.user;
    } catch (error) {
      print("Lỗi đăng nhập bằng Facebook: $error");
      throw error;
    }
  }
}
