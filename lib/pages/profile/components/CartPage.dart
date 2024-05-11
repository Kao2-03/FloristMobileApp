import 'package:florist_mobileapp/Widgets/CartAppBar.dart';
import 'package:florist_mobileapp/Widgets/CartBottomNavBar.dart';
import 'package:florist_mobileapp/Widgets/CartItemSamples.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          CartAppBar(),
          
          Container(
            // temporary height
            height: 700,
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
             )),
            child: Column(children: [
              CartItemSamples(),
            ],),
          )
        ],
      ),
      bottomNavigationBar: CartBottomNavBar(),
      
    );
  }
}