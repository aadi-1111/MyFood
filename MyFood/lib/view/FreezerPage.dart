import 'package:MyFoodLogin/view/FridgePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FreezerPage extends StatefulWidget {
  FreezerPage({Key key}) : super(key: key);

  @override
  _FreezerPageState createState() => _FreezerPageState();
}

class _FreezerPageState extends State<FreezerPage> {
  //FirebaseFirestore db = FirebaseFirestore.getInstance();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _textController = TextEditingController();
  TextEditingController _AmountController = TextEditingController();

  Future getPosts() async {
    var db = FirebaseFirestore.instance;
    final User user = auth.currentUser;
    final uid = user.uid;

    QuerySnapshot qn =
        await db.collection("Users").doc(uid).collection("Drawer").get();

    return qn.docs;
  }

  List<int> amount = <int>[/*2, 0, 10, 6, 52, 4, 0, 2, 1, 2, 3, 4, 5, 6, 7*/];
  List<String> foodItem = <String>[];

  onSubmit() {
    final User user = auth.currentUser;
    final uid = user.uid;
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(uid) // user,user.uid
          .collection("Drawer")
          .doc(_textController.text)
          .set({
        "Name": _textController.text,
        "Type": "Freezer",
        "Amount": 0,
      });
    });
  }

  changeAmount(String Item) {
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .doc("Username02")
          .collection("Drawer")
          .doc(Item)
          .update({"Amount": _AmountController.text});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/images/fridge_section_background.png"),
                    fit: BoxFit.fill)),
            child: Column(
              children: <Widget>[
                //Top of page
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Back button
                    InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FridgePage())),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(width: 3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.only(
                                left: 10, bottom: 24, top: 10, right: 10),
                            width: 60,
                            height: 30,
                            child: Center(
                              child: Text(
                                "Back",
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ))),
                    //Edit Button
                    InkWell(
                        onTap: () => print("Edit button pressed"),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/edit_button.png"),
                                  fit: BoxFit.fill)),
                          margin: EdgeInsets.only(
                              left: 10, bottom: 24, top: 10, right: 30),
                          width: 30,
                          height: 30,
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Textbox to add food
                    Container(
                      width: 275,
                      height: 50,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffe0f7f3),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 3.0),
                            ),
                            hintText: 'Enter a Food Item Here'),
                      ),
                    ),
                    //Add Item Button
                    InkWell(
                        onTap: () => onSubmit(),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/add_button.png"),
                                  fit: BoxFit.fill)),
                          width: 40,
                          height: 40,
                        )),
                  ],
                ),
                //List of items
                Row(
                  children: [
                    Container(
                        child: Padding(
                      padding: EdgeInsets.only(left: 26.5, top: 49),
                      child: Container(
                          width: 353,
                          height: 481,
                          decoration: BoxDecoration(
                              //color: Color(0xff3f6576),
                              color: Colors.blue[200],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )),
                          child: FutureBuilder(
                            future: getPosts(),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Text("Loading..."),
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, index) {
                                      return InkWell(
                                          onTap: () => showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(snapshot
                                                      .data[index]
                                                      .get("Name")),
                                                  content:
                                                      SingleChildScrollView(
                                                          child: ListBody(
                                                              children: <
                                                                  Widget>[
                                                        TextField(
                                                          controller:
                                                              _AmountController,
                                                          decoration:
                                                              InputDecoration(
                                                                  filled: true,
                                                                  fillColor: Color(
                                                                      0xffe0f7f3),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            3.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            3.0),
                                                                  ),
                                                                  hintText:
                                                                      'Change Amount'),
                                                        ),
                                                      ])),
                                                  actions: <Widget>[
                                                    InkWell(
                                                      onTap: () => changeAmount(
                                                          snapshot.data[index]
                                                              .get("Name")),
                                                      child: Container(
                                                        child: Text("Submit"),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }),
                                          child: ListTile(
                                            title: Text(snapshot.data[index]
                                                .get("Name")),
                                            trailing: Text(snapshot.data[index]
                                                .get("Amount")
                                                .toString()),
                                          ));
                                    });
                              }
                            },
                          )),
                    ))
                  ],
                ),
              ],
            )));
  }
}
