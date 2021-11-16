import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userCreate(String email) async {
  CollectionReference user =
      FirebaseFirestore.instance.collection('Users'); //create user collection

  FirebaseAuth authenticate = FirebaseAuth.instance;
  String? uid = authenticate.currentUser?.uid
      .toString(); //gets current registered users ID for collection

  user.doc(uid).set({
    'email': email, //user properties
    'uid': uid
  });
}

Future<String> addDoc(String col, dynamic docVal) async {
  CollectionReference collection = FirebaseFirestore.instance.collection(col);
  try {
    dynamic doc = await collection.add(docVal);
    return doc.id;
  } catch (error) {
    print("Failed to add:$error");
    return "";
  }
}

void updateDoc(String col, String id, dynamic docVal) {
  CollectionReference collection = FirebaseFirestore.instance.collection(col);

  collection
      .doc(id)
      .set(docVal)
      .then((value) => print("Set"))
      .catchError((error) => print("Failed to add:$error"));
}

Future<String> addDocToUser(String col, dynamic docVal) async {
  CollectionReference user = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth authenticate = FirebaseAuth.instance;
  String? uid = authenticate.currentUser?.uid
      .toString(); //gets current registered users ID for collection

  CollectionReference collection = user.doc(uid).collection(col);
  try {
    dynamic doc = await collection.add(docVal);
    return doc.id;
  } catch (error) {
    print("Failed to add:$error");
    return "";
  }
}

void updateDocToUser(String col, String id, dynamic docVal) {
  CollectionReference user = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth authenticate = FirebaseAuth.instance;
  String? uid = authenticate.currentUser?.uid
      .toString(); //gets current registered users ID for collection
  CollectionReference collection = user.doc(uid).collection(col);
  collection
      .doc(id)
      .set(docVal)
      .then((value) => print("Set"))
      .catchError((error) => print("Failed to add:$error"));
}
