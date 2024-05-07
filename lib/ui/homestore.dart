import 'package:flutter/material.dart';

class HomeStore extends StatefulWidget {
  const HomeStore({Key? key}) : super(key: key);

  @override
  State<HomeStore> createState() => _HomeState();
}

class _HomeState extends State<HomeStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
        
          ],
        ),
      ),
    );
  }
}