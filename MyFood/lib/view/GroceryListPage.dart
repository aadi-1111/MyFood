import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  List<String> gl = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getGroceryList(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              List<QueryDocumentSnapshot> data =
              snapshot.data as List<QueryDocumentSnapshot>;
              if(data.isEmpty){
                return Center(
                  child: Text("You have nothing in your groceryList"),
                );
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context,index){
                  return Container(
                    child: ListTile(
                      title: Text(data[index]["name"]),
                      trailing: Text(data[index]["place"]),
                      subtitle: Text("Date:" + data[index]["date"]),
                      onLongPress: () async{
                        await deleteItem(data[index].id);
                        setState(() {});
                      },
                      onTap: () => print("yo"),
                    ),
                  );
                },
              );
            }
            else{
              return CircularProgressIndicator();
            }
        },
      )),
    );
  }
}

Future<List<QueryDocumentSnapshot>> getGroceryList() async {
  List<QueryDocumentSnapshot> arr = [];
  await FirebaseFirestore.instance
      .collection('Users')
      .doc("0WPVnyaGEGOZDM8koHtX4gLnR443")
      .collection("food")
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      arr.add(doc);
    });
  });
  return arr;
}

Future<void> deleteItem(String id) {
  return FirebaseFirestore.instance
      .collection("Users")
      .doc('0WPVnyaGEGOZDM8koHtX4gLnR443')
      .collection("food")
      .doc(id)
      .delete()
      .then((value) => print("Item Deleted"))
      .catchError((error) => print("Failed to delete item: $error"));
}
