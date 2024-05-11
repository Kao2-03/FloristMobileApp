import 'package:florist_mobileapp/pages/myOrder/components/order_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final List _panel = [
    'panel 1',
    'panel 2',
    'panel 3',
    'panel 4',
    'panel 4',
    'panel 4'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _panel.length,
        itemBuilder: (context, index) {
          return OrderPanel();
        });
  }
}
