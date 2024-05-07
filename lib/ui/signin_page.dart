import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants.dart';
import '../ux/register.dart';
import 'ForgotPassword.dart';
import 'homestore.dart';
import '../ux/signin_handle.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _usernameValid = false;
  bool _passwordValid = false;
  bool _rememberMe = false;
  late final AuthService _authService; // Khai báo AuthService

  // Khởi tạo controller cho TextField của username và password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authService = AuthService(); // Khởi tạo AuthService
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Nhập'), // Đổi tiêu đề
        backgroundColor: Constants.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Text(
              Constants.titleTwo, // Tiêu đề
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left, // Căn trái
            ),
            const SizedBox(height: 20.0),
            Text(
              Constants.descriptionTwo, // Mô tả
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left, // Căn trái
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, size: 50, color: Constants.primaryColor), // Icon giỏ hàng
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
                hintText: 'Nhập mật khẩu',
                errorText: !_passwordValid ? 'Vui lòng nhập mật khẩu' : null,
              ),
              onChanged: (value) {
                setState(() {
                  _passwordValid = value.isNotEmpty;
                });
              },
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                ),
                const Text(
                  'Ghi nhớ tài khoản',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // Chuyển đến trang Quên mật khẩu
                    _navigateToForgotPassword(context);
                  },
                  child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200, // Độ rộng của nút
                  child: ElevatedButton(
                    onPressed: () {
                      // Kiểm tra xem username và password có được nhập hay không
                      if (_usernameValid && _passwordValid) {
                        // Nếu đã nhập đủ thông tin, thực hiện chuyển đến trang Trang chủ
                        _signInWithEmailAndPassword(_usernameController.text, _passwordController.text);
                      } else {
                        // Nếu username hoặc password chưa được nhập, hiển thị thông báo
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Thông báo"),
                            content: Text("Vui lòng nhập đầy đủ tên người dùng và mật khẩu"),
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
                    },
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constants.primaryColor),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(15)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Divider(color: Colors.grey),
                  ),
                ),
                Text(
                  'Hoặc đăng nhập bằng',
                  style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Divider(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Xử lý khi nhấn biểu tượng Facebook
                    _signInWithFacebook();
                  },
                  child: const Icon(
                    FontAwesomeIcons.facebook,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 20), // Khoảng cách giữa các biểu tượng
                GestureDetector(
                  onTap: () {
                    // Xử lý khi nhấn biểu tượng Google
                    _signInWithGoogle();
                  },
                  child: const Icon(
                    FontAwesomeIcons.google,
                    size: 40,
                    color: Colors.red, // Đổi màu của biểu tượng Google thành màu chính xác của Google
                  ),
                ),
                const SizedBox(width: 20), // Khoảng cách giữa các biểu tượng
                GestureDetector(
                  onTap: () {
                    // Xử lý khi nhấn biểu tượng Twitter
                    print('Twitter pressed');
                  },
                  child: const Icon(
                    FontAwesomeIcons.twitter,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bạn chưa có tài khoản?',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Chuyển đến trang Đăng ký
                    _navigateToRegister(context);
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text(
                    'Tạo tài khoản',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
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

  // Hàm để chuyển đến trang Quên mật khẩu
  void _navigateToForgotPassword(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPassword()));
  }

  // Hàm để chuyển đến trang Trang chủ
  void _navigateToHome(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeStore()));
  }

  // Hàm để chuyển đến trang Đăng ký
  void _navigateToRegister(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const Register()));
  }

  // Hàm xử lý đăng nhập với email và mật khẩu
  void _signInWithEmailAndPassword(String email, String password) async {
    try {
      // Gọi hàm signInWithEmailAndPassword từ AuthService
      final userCredential = await _authService.signInWithEmailAndPassword(email, password);
      // Nếu đăng nhập thành công, chuyển đến trang Home
      _navigateToHome(context);
    } catch (e) {
      // Xử lý lỗi
      print("Error signing in with email and password: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to sign in with email and password"),
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

  // Hàm xử lý đăng nhập bằng Google
  void _signInWithGoogle() async {
    try {
      // Gọi hàm signInWithGoogle từ AuthService
      final userCredential = await _authService.signInWithGoogle();
      // Nếu đăng nhập thành công, chuyển đến trang Home
      _navigateToHome(context);
    } catch (e) {
      // Xử lý lỗi
      print("Lỗi đăng nhập bằng Google: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Đăng nhập bằng Google thất bại"),
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

  // Hàm xử lý đăng nhập bằng Facebook
  void _signInWithFacebook() async {
    try {
      // Gọi hàm signInWithFacebook từ AuthService
      final userCredential = await _authService.signInWithFacebook();
      // Nếu đăng nhập thành công, chuyển đến trang Home
      _navigateToHome(context);
    } catch (e) {
      // Xử lý lỗi
      print("Lỗi đăng nhập bằng Facebook: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Đăng nhập bằng Facebook thất bại"),
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
}