import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfood/view//dbhelper.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ShoppingList",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.teal[50],
      ),
      home: const ShoppingCartPage(),
    );
  }
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  final textEditingController = TextEditingController();
  bool validated = true;
  String errorText = "";
  String todoEdited = "";

  User? user = FirebaseAuth.instance.currentUser;

  void showAlertDialog() {
    textEditingController.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: const Text(
                "Add Task",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: textEditingController,
                    autofocus: true,
                    onChanged: (_val) {
                      todoEdited = _val;
                    },
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Raleway",
                    ),
                    decoration: InputDecoration(
                      errorText: validated ? null : errorText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            if (textEditingController.text.isEmpty) {
                              setState(() {
                                errorText = "Can't Be Empty";
                                validated = false;
                              });
                            } else if (textEditingController.text.length >
                                512) {
                              setState(() {
                                errorText = "Too may Characters";
                                validated = false;
                              });
                            } else {
                              DatabaseHelper()
                                  .createNewTask(textEditingController.text, user?.uid);
                              Navigator.of(context).pop();
                            }
                          },
                          color: Colors.teal[50],
                          child: const Text(
                            "Add",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Raleway",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(user?.uid)
            .collection("ShoppingList")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data.toString() == 'null') {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showAlertDialog,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.teal[50],
              ),
              appBar: AppBar(
                backgroundColor: Colors.teal[50],
                centerTitle: true,
                title: const Text(
                  "Shopping List",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              body: const Center(
                child: Text(
                  "No Task Available",
                  style: TextStyle(fontFamily: "Raleway", fontSize: 20.0),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.teal[50],
              centerTitle: true,
              title: const Text(
                "Shopping List",
                style: TextStyle(
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot todo = snapshot.data!.docs[index];
                  return Card(
                    elevation: 5.0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        title: Text(
                          todo["Food Item"],
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Raleway",
                          ),
                        ),
                        onLongPress: () {
                          FirebaseFirestore.instance
                              .collection('ShoppingList')
                              .doc(todo.id)
                              .delete();
                        },
                      ),
                    ),
                  );
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: showAlertDialog,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.teal[50],
            ),
          );
        });
  }
}
