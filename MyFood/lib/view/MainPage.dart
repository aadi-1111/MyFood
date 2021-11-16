import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfood/view/GroceryListPage.dart';
import 'package:myfood/view/ShoppingCartPage.dart';
import 'package:myfood/view/BarcodeScanPage.dart';
import './FridgePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ProfilePage.dart';
import 'Menu.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _amountController = TextEditingController();
  DateTime today = DateTime.now();
  //Timestamp currentDate = Timestamp.now();

//Ask for all of the food items from the current user
  Future getPosts() async {
    var db = FirebaseFirestore.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    DateTime twoWeeks = today.add(const Duration(days: 14));

    QuerySnapshot qn = await db
        .collection("Users")
        .doc(uid)
        .collection("Drawer")
        .where("ExpDate", isLessThanOrEqualTo: twoWeeks)
        .get();

    return qn.docs;
  }

  Color expColor(DateTime date) {
    if (date.isBefore(today)) {
      return Colors.red[300]!;
    }
    if (date.isBefore(today.add(const Duration(days: 7)))) {
      return Colors.orange[200]!;
    }
    return Colors.green[300]!;
  }

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
      //This is the mint color for backgrounds
      backgroundColor: Color(0xffe0f7f3),

      body: SafeArea(
        child: Column(
          children: <Widget>[
            //User Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: FutureBuilder(
                    future: getProfilePic(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data == null){
                          return CircleAvatar(maxRadius: 100,backgroundImage: AssetImage('assets/images/user.png'),);
                        }
                        return CircleAvatar(maxRadius: 100,backgroundImage: NetworkImage(snapshot.data.toString()),);
                      }
                      else{
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  iconSize: deviceHeight * .28,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                )
              ],
            ),

            // row for the barcode scan button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // barcode scan button
                // will have to change this to IconButton when we have an icon
                ElevatedButton(
                  child: Icon(Icons.menu, color: Colors.red),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BarcodeScanPage()));
                  },
                )
              ],
            ),

            //Row of 4 buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Menu Button
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Image.asset('assets/images/menu.png'),
                    iconSize: deviceHeight * .1,
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Menu()));
                    },
                  ),
                ),
                //Fridge Button
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Image.asset('assets/images/fridge.png'),
                    iconSize: deviceHeight * .1,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FridgePage()));
                    },
                  ),
                ),
                //Shopping Cart Button
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Image.asset('assets/images/shopping_cart.png'),
                    iconSize: deviceHeight * .1,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShoppingCartPage()));
                    },
                  ),
                ),
                //Grocery List Button
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Image.asset('assets/images/grocery_list.png'),
                    iconSize: deviceHeight * .1,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroceryListPage()));
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: deviceHeight * .01),
                  child: Text(
                    "Foods Expiring Soon",
                    style: TextStyle(
                        fontSize: deviceWidth * .06, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            //Box of text.
            //This will eventually be a "News Feed" that will tell you information about your fridge
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(width: 2)),
                  margin: EdgeInsets.only(
                      bottom: deviceHeight * .02, top: deviceHeight * .01),
                  width: deviceWidth * .9,
                  height: deviceHeight * .14,
                  alignment: Alignment.center,
                  child: FutureBuilder(
                    future: getPosts(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading..."),
                        );
                      } else {
                        List<DocumentSnapshot> data =
                        snapshot.data as List<DocumentSnapshot>;
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                  onTap: () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(data[index].get("Name")),
                                          content: SingleChildScrollView(
                                              child: ListBody(children: <Widget>[
                                            TextField(
                                              controller: _amountController,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0xffe0f7f3),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 3.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.blue,
                                                        width: 3.0),
                                                  ),
                                                  hintText: 'Change Amount'),
                                            ),
                                          ])),
                                          actions: <Widget>[
                                            Text(
                                                data[index].get("ExpDate") == null
                                                    ? 'No expiration date'
                                                    : DateFormat('MM/dd/yyyy')
                                                        .format(data[index]
                                                            .get("ExpDate")
                                                            .toDate())
                                                        .toString()),

                                            //Submit Button
                                            InkWell(
                                              onTap: () {
                                                changeAmount(
                                                    data[index].get("Name"));
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                  height: deviceHeight * .05,
                                                  width: deviceWidth * .15,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[300],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(10)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Submit",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ),

                                            //Cancel Button
                                            InkWell(
                                              onTap: () {
                                                deleteItem(
                                                    data[index].get("Name"));
                                                Navigator.of(context).pop();
                                              },
                                              //Delete Button
                                              child: Container(
                                                  height: deviceHeight * .05,
                                                  width: deviceWidth * .15,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red[300],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: Center(
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            )
                                          ],
                                        );
                                      }),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 5.0),
                                    child: Card(
                                      color: expColor(
                                          data[index].get("ExpDate").toDate()),
                                      child: ListTile(
                                        title: Text(
                                          data[index].get("Name"),
                                          textAlign: TextAlign.left,
                                        ),
                                        trailing: Text(
                                          DateFormat('MM/dd/yyyy')
                                              .format(data[index]
                                                  .get("ExpDate")
                                                  .toDate())
                                              .toString(),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ));
                            });
                      }
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}

Future<String> getProfilePic() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String downloadURL = await firebase_storage.FirebaseStorage.instance
      .ref('profilePics/' + auth.currentUser!.uid)
      .getDownloadURL();
  return downloadURL;
  // Within your widgets:
  // Image.network(downloadURL);
}

