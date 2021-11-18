import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiselect_formfield/multiselect_dialog.dart';
import 'package:myfood/view/MainPage.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:async';
import 'Login.dart';
import 'CameraPage.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String dietsTemp = "";
  List? _myDiets;
  List? _myAllergies;


  Future getPosts() async {
    /*QuerySnapshot dietQuery =
        await db.collection("Users").doc(uid).collection("Diets").get();

    QuerySnapshot allergyQuery =
        await db.collection("Users").doc(uid).collection("Allergies").get();*/
  }

  Widget makeAllergySelection(List<String> initVal){
    return MultiSelectFormField(
      autovalidate: false,
      chipBackGroundColor: Colors.redAccent,
      chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
      checkBoxActiveColor: Colors.red,
      checkBoxCheckColor: Colors.black12,
      dialogShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      title: Text(
        "Allergies",
        style: TextStyle(fontSize: 16),
      ),
      dataSource: [
        {
          "display": "Dairy",
          "value": "Dairy",
        },
        {
          "display": "Eggs",
          "value": "Eggs",
        },
        {
          "display": "Tree Nuts",
          "value": "Tree Nuts",
        },
        {
          "display": "Peanuts",
          "value": "Peanuts",
        },
        {
          "display": "ShellFish",
          "value": "ShellFish",
        },
        {
          "display": "Wheat",
          "value": "Wheat",
        },
        {
          "display": "Soy",
          "value": "Soy",
        },
        {
          "display": "Fish",
          "value": "Fish",
        },
        {
          "display": "Gluten",
          "value": "Gluten",
        },
        {
          "display": "Food Coloring",
          "value": "Food Coloring",
        },
      ],
      textField: 'display',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCEL',
      hintWidget: Text('Please choose one or more'),
      initialValue: initVal,
      onSaved: (value) async {
        if (value == null) return;
        await allergyErase();
        setState(() {
          List<String> temp = [];
          _myAllergies = value;
          _myAllergies!.forEach((element) {temp.add(element.toString());});
          print(temp);
          allergySubmit(temp);
        });
      },
    );
  }

  Widget makeDietSelection(List<String> initalListVal){
    return MultiSelectFormField(
      autovalidate: false,
      chipBackGroundColor: Colors.lightGreen,
      chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
      checkBoxActiveColor: Colors.lightGreen,
      checkBoxCheckColor: Colors.green,
      dialogShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      title: Text(
        "Diets",
        style: TextStyle(fontSize: 16),
      ),
      dataSource: [
        {
          "display": "Ketogenic",
          "value": "Ketogenic",
        },
        {
          "display": "Vegan",
          "value": "Vegan",
        },
        {
          "display": "Vegetarian",
          "value": "Vegetarian",
        },
        {
          "display": "Kosher",
          "value": "Kosher",
        },
        {
          "display": "Paleo",
          "value": "Paleo",
        },
        {
          "display": "Mediterranean",
          "value": "Mediterranean",
        },
      ],
      textField: 'display',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCEL',
      hintWidget: Text('Please choose one or more'),
      initialValue: initalListVal,
      onSaved: (value) async {
        if (value == null) return;
        await dietErase();
        setState(() {
          List<String> temp = [];
          _myDiets = value;
          _myDiets!.forEach((element) {temp.add(element.toString());});
          print(temp);
          dietSubmit(temp);
        });
      },
    );
  }

  Future getAllergy() async {
    List<String> ans = [];
    var db = FirebaseFirestore.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    QuerySnapshot qn =
    await db.collection("Users").doc(uid).collection("Allergies").get();

    qn.docs.forEach((element) {
      ans.add(element["Name"]);
    });
    return ans;
  }

  Future getDiet() async {
    List<String> ans = [];
    var db = FirebaseFirestore.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    QuerySnapshot qn =
        await db.collection("Users").doc(uid).collection("Diets").get();

    qn.docs.forEach((element) {
      ans.add(element["Name"]);
    });
    return ans;
  }

  dietErase() async{
    final User? user = auth.currentUser;
    final uid = user?.uid;

    await FirebaseFirestore.instance
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

  allergyErase() async{
    final User? user = auth.currentUser;
    final uid = user?.uid;

    await FirebaseFirestore.instance
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

    for (int i = 0; i < allergies.length; i++) {
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

    for (int i = 0; i < diets.length; i++) {
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
  //List? _dietList = _diets.map((diet) => {"display" : diet, "value" : diet}).toList();

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
      .map((allergy) => MultiSelectDialogItem(allergy, allergy))
      .toList();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myDiets = [];
    _myAllergies = [];
  }

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
                      if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.data == null){
                          return Image.asset('assets/images/user.png');
                        }
                        return CircleAvatar(maxRadius: 100,backgroundImage: NetworkImage(snapshot.data.toString()),);
                      }
                      else{
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  iconSize: deviceHeight * .28,
                  onPressed: () async {
                    await CameraSetup.runCamera(context);
                    setState(() {});
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
                    child: FutureBuilder(
                      future: getDiet(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data != null){
                            List<String> data = snapshot.data as List<String>;
                            return makeDietSelection(data);
                          }
                          else{
                            return makeDietSelection([]);
                          }
                        }
                        else{
                          return CircularProgressIndicator();
                        }

                      },
                    ))
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
                    child: FutureBuilder(
                      future: getAllergy(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data != null){
                            List<String> data = snapshot.data as List<String>;
                            return makeAllergySelection(data);
                          }
                          else{
                            return makeAllergySelection([]);
                          }
                        }
                        else{
                          return CircularProgressIndicator();
                        }
                      },
                    ))
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
