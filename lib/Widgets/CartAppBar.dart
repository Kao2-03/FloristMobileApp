import 'package:flutter/material.dart';

class CartAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(children: [
      InkWell(
        onTap:() {
        // goes back tô previous screen/page 
        Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          size: 30,
          color: Colors.pink
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          "Cart",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
      ),
      Icon(
        Icons.more_vert,
        size: 30,
        color: Colors.pink
      ),
      ]),
      );
  }
}