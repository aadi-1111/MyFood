import 'package:flutter/material.dart';
import 'package:myfood/view/FridgePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ProducePage extends StatefulWidget {
  ProducePage({Key? key}) : super(key: key);

  @override
  _ProducePageState createState() => _ProducePageState();
}

class _ProducePageState extends State<ProducePage> {
  late DateTime _dateTime;
  //Initialize the database, text controller for food item, and amount controller for food item
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _textController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  //Ask for all of the food items from the current user
  Future getPosts() async {
    var db = FirebaseFirestore.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    QuerySnapshot qn = await db
        .collection("Users")
        .doc(uid)
        .collection("Drawer")
        .where("Type", isEqualTo: "Produce")
        .get();

    return qn.docs;
  }

//Function that is called when a new item is submitted.
//Submits the new food item from the text controller to the current user and setting its type to meat
  onSubmit(String name, String amount, DateTime expdate) {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    // print(date);
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(uid) // user,user.uid
          .collection("Drawer")
          .doc(name)
          .set({
        "Name": name,
        "Type": "Produce",
        "Amount": amount,
        "ExpDate": expdate
      });
    });
  }

//Function that is called when submitting a new amount for a food item.
//Sets the new amount of the current item for the current user to what is in the amount text field
  changeAmount(String item) {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("Drawer")
          .doc(item)
          .update({"Amount": _amountController.text});
    });
    _amountController.clear();
  }

//Deletes the current food item
  deleteItem(String item) {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("Drawer")
          .doc(item)
          .delete();
    });
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            constraints: BoxConstraints.expand(),
            //Set background image
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
                                left: deviceWidth * .05,
                                top: deviceHeight * .02),
                            width: deviceWidth * .15,
                            height: deviceHeight * .045,
                            child: Center(
                              child: Text(
                                "Back",
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontSize: deviceWidth * .03,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ))),
                  ],
                ),
                //Row with textbox and Add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Textbox to add food
                    Container(
                      width: deviceWidth * .6,
                      height: deviceHeight * .15,
                      margin: EdgeInsets.only(top: deviceHeight * .02),
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
                        onTap: () {
                          //Amount Alert
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(_textController.text),
                                  content: SingleChildScrollView(
                                      child: ListBody(children: <Widget>[
                                    TextField(
                                      controller: _amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xffe0f7f3),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 3.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 3.0),
                                          ),
                                          hintText: 'Set Amount'),
                                    ),
                                    // Drop down UOM goes here
                                    new DropdownButton<String>(
                                      items: <String>[
                                        'Boxes',
                                        'Bags',
                                        'Pounds',
                                        'Ounces'
                                      ].map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (_) {},
                                    )
                                  ])),
                                  actions: <Widget>[
                                    //Expiration date picker
                                    ElevatedButton(
                                      child: Text('Expiration Date'),
                                      onPressed: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2021),
                                                lastDate: DateTime(2100))
                                            .then((expdate) {
                                          setState(() {
                                            _dateTime = expdate!;
                                          });
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red, // background
                                        onPrimary: Colors.white, // foreground
                                      ),
                                    ),

                                    //Submit Button
                                    InkWell(
                                      onTap: () {
                                        onSubmit(_textController.text,
                                            _amountController.text, _dateTime);
                                        Navigator.of(context).pop();
                                        _textController.clear();
                                      },
                                      child: Container(
                                          height: deviceHeight * .05,
                                          width: deviceWidth * .15,
                                          decoration: BoxDecoration(
                                              color: Colors.green[300],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Center(
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ),

                                    //Cancel Button
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                          height: deviceHeight * .05,
                                          width: deviceWidth * .15,
                                          decoration: BoxDecoration(
                                              color: Colors.red[300],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Center(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          )),
                                    )
                                  ],
                                );
                              });
                        },
                        //Actual "+" button
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/add_button.png"),
                                  fit: BoxFit.fill)),
                          width: deviceWidth * .095,
                          height: deviceHeight * .06,
                          margin: EdgeInsets.only(
                              bottom: deviceHeight * .05,
                              left: deviceWidth * .01),
                        )),
                  ],
                ),

                //List of items
                Row(
                  children: [
                    Container(
                      child: Container(
                          margin: EdgeInsets.only(
                              bottom: deviceHeight * 0,
                              left: deviceWidth * 0.062),
                          width: deviceWidth * .86,
                          height: deviceHeight * .707,
                          decoration: BoxDecoration(
                              //color: Color(0xff3f6576),
                              color: Colors.green[300],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )),
                          //This is where the items are loaded in from the DB
                          child: FutureBuilder(
                            future: getPosts(),
                            builder: (_, snapshot) {
                              List<DocumentSnapshot> data =
                                  snapshot.data as List<DocumentSnapshot>;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Text("Loading..."),
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (_, index) {
                                      //When an item is clicked, a dialog box to change the amount of that item or to delete the item appears
                                      return InkWell(
                                          onTap: () => showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      data[index].get("Name")),
                                                  content:
                                                      SingleChildScrollView(
                                                          child: ListBody(
                                                              children: <
                                                                  Widget>[
                                                        TextField(
                                                          controller:
                                                              _amountController,
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
                                                    Text(data[index].get(
                                                                "ExpDate") ==
                                                            null
                                                        ? 'No expiration date'
                                                        : DateFormat(
                                                                'MM/dd/yyyy')
                                                            .format(data[index]
                                                                .get("ExpDate")
                                                                .toDate())
                                                            .toString()),

                                                    //Submit Button
                                                    InkWell(
                                                      onTap: () {
                                                        changeAmount(data[index]
                                                            .get("Name"));
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Container(
                                                          height: deviceHeight *
                                                              .05,
                                                          width:
                                                              deviceWidth * .15,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .green[300],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "Submit",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                    ),

                                                    //Cancel Button
                                                    InkWell(
                                                      onTap: () {
                                                        deleteItem(data[index]
                                                            .get("Name"));
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      //Delete Button
                                                      child: Container(
                                                          height: deviceHeight *
                                                              .05,
                                                          width:
                                                              deviceWidth * .15,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .red[300],
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                          child: Center(
                                                            child: Text(
                                                              "Delete",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                );
                                              }),
                                          //Individual Items
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0.0,
                                                  horizontal: 10.0),
                                              child: Card(
                                                  color: Colors.white,
                                                  child: ListTile(
                                                    title: Text(
                                                      data[index].get("Name"),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    trailing: Text(
                                                      data[index]
                                                          .get("Amount")
                                                          .toString(),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ))));
                                    });
                              }
                            },
                          )),
                    )
                  ],
                ),
              ],
            )));
  }
}
