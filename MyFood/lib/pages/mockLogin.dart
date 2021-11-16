import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan[50],
        body: Center(
            child: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: 500,
              height: 200,
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.only(right: 10.0),
              child: Image(
                image: AssetImage('assests/logo_MyFood.png'),
              ),
            ),
            Container(
                width: 300.0,
                height: 40.0,
                margin: EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: TextFormField(
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Username',
                      hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        // borderRadius: BorderRadius.circular(5.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: (Colors.orange[700])!),
                      ),
                    ))),
            Container(
                width: 300.0,
                height: 40.0,
                child: TextFormField(
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Password',
                      hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: (Colors.orange[700])!),
                      ),
                    ))),
            SizedBox(height: 45.0),
            Container(
              height: 30.0,
              width: 130,
              child: Material(
                borderRadius: BorderRadius.circular(5.0),
                child: RaisedButton(
                    onPressed: () {
                      print("You have logged in!");
                    },
                    color: Colors.orange[700],
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ),
            ),
            SizedBox(height: 40),
            Container(
                child: InkWell(
              child: Text(
                "Forgot Passoword",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            )),
            SizedBox(height: 10),
            Container(
                child: InkWell(
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            )),
          ]),
        )));
  }
}
