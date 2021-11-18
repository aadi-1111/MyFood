// the database helper class
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewTask(String food, String location,
      String? userId) async {
    try {
      await _firestore
          .collection("Users")
          .doc(userId)
          .collection("Shopping List")
          .doc()
          .set({
        "Food Item": food,
        "Purchase Location": location,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}