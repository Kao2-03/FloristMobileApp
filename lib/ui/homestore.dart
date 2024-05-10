import 'package:florist_mobileapp/pages/profile/user_account.dart';
import 'package:flutter/material.dart';

class HomeStore extends StatefulWidget {
  const HomeStore({super.key});

  @override
  State<HomeStore> createState() => _HomeState();
}

class _HomeState extends State<HomeStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đây là trang chủ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(150, 60)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFFF5F6F9)),
                    padding:
                        MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    // Điều hướng đến màn hình mới khi người dùng nhấn vào nút
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserPage()),
                    );
                  },
                  child: Text(
                    'Profile',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
