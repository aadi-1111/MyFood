import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late String email = "";
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[700],
        elevation: 0.0,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                width: 300.0,
                height: 40.0,
                margin: EdgeInsets.only(
                  bottom: 5.0,
                ),
                padding: EdgeInsets.only(right: 10.0),
                child: Text("Enter the email associated with your account."),
              ),
              Container(
                width: 350,
                height: 40.0,
                margin: EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please Enter Your Email";
                    } else {
                      email = value!;
                    }
                    return null;
                  },
                  // controller: emailTextController,
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
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email)
                        .then((value) => print(
                            "Check your email, We have sent you Reset Email."));

                    //this is the dialog for the submit button. when the reset email is sent.
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Almost There!"),
                          content: Text(
                              "Please check you email and click the link to reset password."),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Okay"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } //Send user email for password
                },
                child: Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
