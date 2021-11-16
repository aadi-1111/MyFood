import 'Login.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("+"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

      ),
    );
  }
}
