import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myfood/theme/approutes.dart';
import 'package:myfood/net/firestore.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

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
                image: AssetImage("assets/images/MyFoodLogo.png"),
              ),
            ),
            Container(
                width: 300.0,
                height: 40.0,
                margin: EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: TextFormField(
                    controller: nameTextController,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        // borderRadius: BorderRadius.circular(5.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.orange[700]!),
                      ),
                    ))),
            Container(
                width: 300.0,
                height: 40.0,
                child: TextFormField(
                    controller: emailTextController,
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
                          borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.orange[700]!),
                      ),
                    ))),
            SizedBox(height: 25),
            Container(
                width: 300.0,
                height: 40.0,
                margin: EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: TextFormField(
                    obscureText: true,
                    controller: passwordTextController,
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
                    ))),
            Container(
                width: 300.0,
                height: 40.0,
                margin: EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: TextFormField(
                    obscureText: true,
                    controller: confirmPasswordTextController,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        // borderRadius: BorderRadius.circular(5.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.orange[700]!),
                      ),
                    ))),
            SizedBox(height: 25.0),
            Container(
              height: 30.0,
              width: 130,
              child: Material(
                borderRadius: BorderRadius.circular(5.0),
                child: RaisedButton(
                    onPressed: () async {
                      await Firebase.initializeApp();
                      try {
                        UserCredential user = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailTextController.text.trim(),
                                password: passwordTextController.text.trim());

                        User? update = FirebaseAuth.instance.currentUser;
                        update?.updateProfile(
                            displayName: emailTextController.text);

                        userCreate(emailTextController.text);

                        Navigator.of(context).pushNamed(Routes.auth_login);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('Password too weak');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                      //Validate code with backend to create user
                      //If validated, create user on backend and navigate to main menu
                    },
                    color: Colors.orange[700],
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ),
            ),
            SizedBox(height: 25),
            Container(
              height: 30.0,
              width: 130,
              child: Material(
                borderRadius: BorderRadius.circular(5.0),
                child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.orange[700],
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ),
            ),
          ]),
        )));
  }
}
