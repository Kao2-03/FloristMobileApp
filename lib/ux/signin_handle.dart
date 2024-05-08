import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // URI chuyển hướng
  final String redirectUri = 'https://floristmobile-303a5.firebaseapp.com/__/auth/handler';

  // Đăng nhập bằng email và mật khẩu
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (error) {
      print('Error signing in with email and password: $error');
      rethrow;
    }
  }

  // Đăng ký bằng email và mật khẩu
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (error) {
      print('Error registering with email and password: $error');
      rethrow;
    }
  }

  // Kiểm tra xem email đã được sử dụng hay chưa
  Future<bool> isEmailAlreadyUsed(String email) async {
    try {
      final List<String> providers = await _auth.fetchSignInMethodsForEmail(email);
      return providers.isNotEmpty;
    } catch (error) {
      print('Error checking if email is already used: $error');
      rethrow;
    }
  }

  // Kiểm tra mật khẩu có đủ mạnh không (ít nhất 8 kí tự, bao gồm chữ và số)
  bool isPasswordStrongEnough(String password) {
    final RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  // Đăng nhập bằng Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        return user;
      } else {
        print('Google sign in aborted');
        return null;
      }
    } catch (error) {
      print('Google sign in failed: $error'); // In ra lỗi khi đăng nhập thất bại
      rethrow;
    }
  }
  // Đăng nhập bằng Facebook
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email']);

      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final UserCredential authResult = await _auth.signInWithCredential(facebookAuthCredential);
      final User? user = authResult.user;

      return user;
    } catch (error) {
      print('Facebook sign in failed: $error');
      rethrow;
    }
  }

  // Hiển thị pop-up thông báo đăng nhập thành công
  void showLoginSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng nhập thành công'),
          content: const Text('Bạn đã đăng nhập thành công.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị pop-up thông báo đăng ký thành công
  void showRegisterSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng ký thành công'),
          content: const Text('Bạn đã đăng ký thành công.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}