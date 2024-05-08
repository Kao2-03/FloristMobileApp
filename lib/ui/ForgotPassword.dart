import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../ux/reset_password.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key, Key? key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController _emailController;
  bool _emailValid = false;
  bool _emailExists = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quên Mật Khẩu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            const Icon(
              FontAwesomeIcons.lock,
              size: 100,
              color: Colors.yellow,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Nhập địa chỉ email của bạn:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Nhập địa chỉ email của bạn',
              ),
              onChanged: (value) {
                setState(() {
                  _emailValid = value.isNotEmpty;
                });
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _emailValid ? _resetPassword : null,
              child: const Text('Gửi mã xác thực'),
            ),
            if (_emailExists)
              const Text(
                'Email không tồn tại. Vui lòng kiểm tra lại.',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  void _resetPassword() async {
    bool exists = await _checkEmailExists(_emailController.text);

    if (exists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPassword(email: _emailController.text),
        ),
      );
    } else {
      setState(() {
        _emailExists = true;
      });
    }
  }

  Future<bool> _checkEmailExists(String email) async {
    try {
      // Lấy reference đến collection "users"
      CollectionReference users = FirebaseFirestore.instance.collection('user');

      // Thực hiện truy vấn để kiểm tra xem có tài liệu nào có email tương tự như đã nhập hay không
      QuerySnapshot<Object?> snapshot = await users.where('email', isEqualTo: email).get();

      // Trả về true nếu có ít nhất một tài liệu chứa email trong collection "users"
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      // Xử lý các trường hợp ngoại lệ
      print('Error: $e');
      return false;
    }
  }
}