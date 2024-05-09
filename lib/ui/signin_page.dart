import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants.dart';
import '../ux/auth_service.dart';
import 'package:florist_mobileapp/ui/register_form.dart';
import 'ForgotPassword.dart';
import 'homestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _checkRememberMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Text(
              Constants.titleTwo,
              style:  TextStyle(
                fontSize: 70.0,
                fontWeight: FontWeight.bold,
                color: Constants.primaryColor,
              ),
              textAlign: TextAlign.left, // Căn trái
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Text(
                  Constants.titleThree,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Constants.basicColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  Constants.titleFour,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Constants.kemColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),

            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 50, color: Constants.primaryColor), // Icon giỏ hàng
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Nhập email',
                errorText: !_usernameValid ? 'Vui lòng nhập email' : null,
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
                border: const OutlineInputBorder(),
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
                const Spacer(),
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
                SizedBox(
                  width: 200, // Độ rộng của nút
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_usernameValid && _passwordValid) {
                        // Nếu đã nhập đủ thông tin, thực hiện đăng nhập
                        await _signInWithEmailAndPassword(_usernameController.text, _passwordController.text);
                      } else {
                        _showAlertDialog("Thông báo", "Vui lòng nhập đầy đủ email và mật khẩu");
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Constants.primaryColor),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(15)),
                    ),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(color: Colors.grey),
                  ),
                ),
                Text(
                  'Hoặc đăng nhập bằng',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(color: Colors.grey),
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
                  icon: const Icon(Icons.person_add,color: Colors.black,),
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterForm()));
  }

  // Hàm đăng nhập bằng email và password
  Future<void> _signInWithEmailAndPassword(String email, String password) async {
    try {
      // Thực hiện đăng nhập bằng email và password từ AuthService
      final userCredential = await _authService.signInWithEmailAndPassword(email, password);

      if (userCredential != null) {
        // Hiển thị popup thông báo đăng nhập thành công
        _showAlertDialog("Success", "Đăng nhập thành công");
        // Nếu đăng nhập thành công, chuyển đến trang Home
        _navigateToHome(context);

        // Lưu thông tin tài khoản nếu người dùng chọn "Ghi nhớ tài khoản"
        if (_rememberMe) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('rememberMe', true);
          await prefs.setString('username', email);
          await prefs.setString('password', password);
        }
      } else {
        // Hiển thị popup thông báo đăng nhập thất bại
        _showAlertDialog("Error", "Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.");
      }
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi FirebaseAuthException
      String errorMessage = "Đăng nhập thất bại. ";
      if (e.code == 'user-not-found') {
        errorMessage += "Người dùng không tồn tại.";
      } else if (e.code == 'wrong-password') {
        errorMessage += "Sai mật khẩu.";
      } else {
        errorMessage += "Lỗi không xác định: ${e.message}";
      }
      _showAlertDialog("Error", errorMessage);
    } catch (e) {
      // Xử lý lỗi khác
      print("Lỗi đăng nhập: $e");
      _showAlertDialog("Error", "Đăng nhập thất bại\nLỗi đăng nhập: $e");
    }
  }

  // Hàm đăng nhập bằng Google
  void _signInWithGoogle() async {
    try {
      // Gọi hàm signInWithGoogle từ AuthService
      final userCredential = await _authService.signInWithGoogle();

      // Hiển thị popup thông báo đăng nhập thành công
      _showAlertDialog("Success", "Đăng nhập thành công");

      // Nếu đăng nhập thành công, chuyển đến trang Home
      _navigateToHome(context);
    } catch (e) {
      // Xử lý lỗi
      print("Lỗi đăng nhập bằng Google: $e");
      // Hiển thị popup thông báo lỗi
      _showAlertDialog("Error", "Đăng nhập bằng Google thất bại\nLỗi đăng nhập: $e");
    }
  }

  // Hàm xử lý đăng nhập bằng Facebook
  void _signInWithFacebook() async {
    try {
      // Gọi hàm signInWithFacebook từ AuthService
      final userCredential = await _authService.signInWithFacebook();

      // Hiển thị popup thông báo đăng nhập thành công
      _showAlertDialog("Success", "Đăng nhập thành công");

      // Nếu đăng nhập thành công, chuyển đến trang Home
      _navigateToHome(context);
    } catch (e) {
      // Xử lý lỗi
      print("Lỗi đăng nhập bằng Facebook: $e");
      // Hiển thị popup thông báo lỗi
      _showAlertDialog("Error", "Đăng nhập bằng Facebook thất bại\nLỗi đăng nhập: $e");
    }
  }

  // Hàm kiểm tra trạng thái "Ghi nhớ tài khoản" từ SharedPreferences
  void _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    if (rememberMe) {
      String? savedUsername = prefs.getString('username');
      String? savedPassword = prefs.getString('password');
      if (savedUsername != null && savedPassword != null) {
        setState(() {
          _usernameController.text = savedUsername;
          _passwordController.text = savedPassword;
          _usernameValid = true;
          _passwordValid = true;
          _rememberMe = true;
        });
      }
    }
  }

  // Hàm hiển thị hộp thoại cảnh báo
  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
