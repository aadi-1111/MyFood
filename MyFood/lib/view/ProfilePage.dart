import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfood/view/MainPage.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:async';
import 'Login.dart';
import 'CameraPage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future getPosts() async {
    /*QuerySnapshot dietQuery =
        await db.collection("Users").doc(uid).collection("Diets").get();

    QuerySnapshot allergyQuery =
        await db.collection("Users").doc(uid).collection("Allergies").get();*/
  }

  Future getDiet() async {
    var db = FirebaseFirestore.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    QuerySnapshot qn =
        await db.collection("Users").doc(uid).collection("Diets").get();

    return qn.docs.toList();
  }

  dietErase() {
    final User? user = auth.currentUser;
    final uid = user?.uid;

    FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Diets")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  allergyErase() {
    final User? user = auth.currentUser;
    final uid = user?.uid;

    FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Allergies")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  allergySubmit(List<String> allergies) {
    final User? user = auth.currentUser;
    final uid = user?.uid;

    for (int i = 0; i <= allergies.length; i++) {
      setState(() {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(uid) // user,user.uid
            .collection("Allergies")
            .doc(allergies[i])
            .set({"Name": allergies[i]});
      });
    }
  }

  dietSubmit(List<String> diets) {
    final User? user = auth.currentUser;
    final uid = user?.uid;

    for (int i = 0; i <= diets.length; i++) {
      setState(() {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(uid) // user,user.uid
            .collection("Diets")
            .doc(diets[i])
            .set({"Name": diets[i]});
      });
    }
  }

  Future dietSubmitWithSleep(diets) {
    return new Future.delayed(
        const Duration(seconds: 1), () => dietSubmit(diets));
  }

  Future allergySubmitWithSleep(allergies) {
    return new Future.delayed(
        const Duration(seconds: 1), () => allergySubmit(allergies));
  }

  static List<String> _diets = [
    "Ketogenic",
    "Vegan",
    "Vegetarian",
    "Kosher",
    "Paleo",
    "Mediterranean",
  ];
  final _dietList =
      _diets.map((diet) => MultiSelectItem<String>(diet, diet)).toList();

  static List<String> _allergies = [
    "Dairy",
    "Eggs",
    "Tree Nuts",
    "Peanuts",
    "Shellfish",
    "Wheat",
    "Soy",
    "Fish",
    "Gluten",
    "Food Coloring",
  ];
  final _allergyList = _allergies
      .map((allergy) => MultiSelectItem<String>(allergy, allergy))
      .toList();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xffe0f7f3),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Back button
                InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainPage())),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(width: 3),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        margin: EdgeInsets.only(
                            left: deviceWidth * .05, top: deviceHeight * .02),
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
                    CameraSetup.runCamera(context);
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Diet",
                  style: TextStyle(
                      fontSize: deviceHeight * .05, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    //color: Colors.red,
                    width: deviceWidth * .8,
                    //constraints: BoxConstraints(),
                    //alignment: Alignment.center,
                    child: MultiSelectDialogField(
                        title: Text(
                          "Diets",
                        ),
                        height: deviceHeight * .6,
                        items: _dietList,
                        buttonText: Text(
                          "Select Diets That Apply to You",
                        ),
                        buttonIcon: Icon(Icons.dinner_dining),
                        cancelText: Text("Cancel"),
                        //We need to load in the users current diet from the databse so that the database and front end are synced
                        //Same applies for the allergies section
                        //initialValue:
                        confirmText: Text("OK"),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                              color: Colors.black,
                              width: 5,
                              style: BorderStyle.solid),
                        )),
                        searchable: true,
                        searchHint: "Search for your specific diet",
                        selectedColor: Colors.green[800],
                        onConfirm: (results) {
                          dietErase();
                          dietSubmitWithSleep(results);
                        }))
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: deviceHeight * .02),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Allergies",
                  style: TextStyle(
                      fontSize: deviceHeight * .05, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    //color: Colors.red,
                    width: deviceWidth * .8,
                    //constraints: BoxConstraints(),
                    //alignment: Alignment.center,
                    child: MultiSelectDialogField(
                        title: Text(
                          "Allergies",
                        ),
                        height: deviceHeight * .6,
                        items: _allergyList,
                        buttonText: Text(
                          "Select Allergies That Apply to You",
                        ),
                        buttonIcon: Icon(Icons.local_dining),
                        cancelText: Text("Cancel"),
                        confirmText: Text("OK"),
                        //initialValue: _allergies,
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                              color: Colors.black,
                              width: 5,
                              style: BorderStyle.solid),
                        )),
                        searchable: true,
                        searchHint: "Search for your allergies",
                        selectedColor: Colors.green[800],
                        onConfirm: (results) {
                          allergyErase();
                          allergySubmitWithSleep(results);
                        }))
              ],
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        bottom: deviceHeight * 0, left: deviceWidth * 0.062),
                    width: deviceWidth * .9,
                    height: deviceHeight * .2,
                    child: FutureBuilder(
                        future: getDiet(),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Text("Loading..."),
                            );
                          } else {
                            List<DocumentSnapshot> data =
                            snapshot.data as List<DocumentSnapshot>;
                            return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (_, index) {
                                  return Text(data[index].get("Name"));
                                });
                          }
                        }))
              ],
            ),
                ElevatedButton(
                    onPressed: (){
                      auth.signOut();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (e) => false);
                    },
                    child: Text("Logout"))
          ])),
        ));
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
