import 'package:flutter/material.dart';
import '../constants.dart';
import 'signin_handle.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final AuthService _authService;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _usernameValid = true;
  bool _passwordValid = true;
  bool _confirmPasswordValid = true;
  bool _emailValid = true;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  void register() {
    if (_usernameValid && _passwordValid && _confirmPasswordValid && _emailValid) {
      _authService.isEmailAlreadyUsed(_emailController.text).then((isUsed) {
        if (!isUsed) {
          if (_authService.isPasswordStrongEnough(_passwordController.text)) {
            _authService.registerWithEmailAndPassword(_emailController.text, _passwordController.text).then((user) {
              if (user != null) {
                _authService.showRegisterSuccessPopup(context);
              } else {
                print('Đăng ký không thành công');
              }
            }).catchError((error) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Thông báo"),
                  content: Text("Đăng ký không thành công: $error"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            });
          } else {
            setState(() {
              _passwordValid = false;
            });
          }
        } else {
          setState(() {
            _emailValid = false;
          });
        }
      }).catchError((error) {
        print('Lỗi kiểm tra email đã sử dụng: $error');
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Thông báo"),
          content: Text("Vui lòng điền đầy đủ thông tin"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Ký'),
        backgroundColor: Constants.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Text(
              Constants.titleTwo,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20.0),
            Text(
              Constants.descriptionTwo,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, size: 50, color: Constants.primaryColor),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tên người dùng',
                hintText: 'Nhập tên người dùng',
                errorText: !_usernameValid ? 'Vui lòng nhập tên người dùng' : null,
              ),
              onChanged: (value) {
                setState(() {
                  _usernameValid = value.isNotEmpty;
                });
              },
            ),
            const SizedBox(height: 15.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mật khẩu',
                hintText: 'Nhập lại mật khẩu',
                errorText: !_passwordValid ? 'Mật khẩu phải có ít nhất 8 kí tự và chứa chữ và số.' : null,
              ),
              onChanged: (value) {
                setState(() {
                  _passwordValid = _authService.isPasswordStrongEnough(value);
                });
              },
            ),
            const SizedBox(height: 15.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Xác nhận mật khẩu',
                hintText: 'Xác nhận mật khẩu',
                errorText: !_confirmPasswordValid ? 'Vui lòng xác nhận mật khẩu' : null,
              ),
              onChanged: (value) {
                setState(() {
                  _confirmPasswordValid = value.isNotEmpty && value == _passwordController.text;
                });
              },
            ),
            const SizedBox(height: 15.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nhập email',
                hintText: 'Nhập email',
                errorText: !_emailValid ? 'Vui lòng nhập email' : null,
              ),
              onChanged: (value) {
                setState(() {
                  _emailValid = value.isNotEmpty;
                });
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: register,
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Constants.primaryColor),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(15)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}