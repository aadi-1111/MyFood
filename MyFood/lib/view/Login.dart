import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myfood/theme/approutes.dart';

import './Register.dart';
import './ForgotPassword.dart';
import './MainPage.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final bool userCheck = false;
  final bool passCheck = false;
  var uid;

  Future<void> invalidInput(String statement) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.cyan[50],
          title: Text(
            'Invalid Input',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange[700],
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  statement,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Understood',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void submit(String username, String password) {
    setState(() {
      //Will send the username and password to the back end
      //It will then get back a bool for the username first
      //If username exists, then will give back a bool for the password
      //If both are true, then go to the user's menu
      //If even one is false, the user must re input the Username and/or Password
      if (userCheck) {
        if (passCheck) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        } else if (password == '') {
          invalidInput("No Password Received");
        } else {
          invalidInput("Invalid Password for this Username");
        }
      } else if (username == '') {
        invalidInput("No Username Received");
      } else {
        invalidInput('Username ' + username + ' does not exist');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              child: Image.asset(
                "assets/images/MyFoodLogo.png",
                width: size.width,
              ),
            ),
            Container(
              width: 300.0,
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextFormField(
                    controller: userController,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Email',
                      hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        // borderRadius: BorderRadius.circular(5.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.orange[700]!),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
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
                        // borderRadius: BorderRadius.circular(5.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.orange[700]!),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 30,
                    width: 130,
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      child: ElevatedButton(
                        onPressed: () async {
                          await Firebase.initializeApp();
                          try {
                            UserCredential user = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: userController.text,
                                    password: passwordController.text);
                            //final uid = user.user.uid;
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (e) => false);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("User not Found"),
                              ));
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Wrong password provided for that user."),
                              ));
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Error"),
                              ));
                            }
                          }
                        },

                        child: Center(
                          child: Text('Log In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 30,
                    width: 155,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword()));
                      },
                      child: Center(
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    height: 30,
                    width: 90,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
