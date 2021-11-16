import 'package:myfood/view/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:myfood/view/FreezerPage.dart';
import 'package:myfood/view/PantryPage.dart';
import 'package:myfood/view/AllFoodPage.dart';
import 'package:myfood/view/DairyPage.dart';
import 'package:myfood/view/ProducePage.dart';
import 'MeatPage.dart';

class FridgePage extends StatefulWidget {
  FridgePage({Key? key}) : super(key: key);

  @override
  _FridgePageState createState() => _FridgePageState();
}

/* // commented out because they aren't needed currently but might be
class StatusDialog extends StatefulWidget {
  State<StatefulWidget> createState() {
    return StatusDialogState();
  }
}

class StatusDialogState extends State<StatusDialog> {
  Widget build(BuildContext context) {
    return;
  }
} */

class _FridgePageState extends State<FridgePage> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        //Container that fills up the whole page to place the background image
        body: SafeArea(
          child: Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/fridge_page_background1.png"),
                fit: BoxFit.fill)),
      child: Column(
          children: <Widget>[
            //Top of page
            Row(
              children: [
                //Back button here

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
                        )))
              ],
            ),

            //First Row
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              //
              //Freezer Box
              InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FreezerPage())),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/ice.png'),
                          fit: BoxFit.fill,
                        ),
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    width: deviceWidth * .4,
                    height: deviceHeight * .241,
                    margin: EdgeInsets.only(
                        left: deviceWidth * .053, top: deviceHeight * .015),
                    child: Center(
                        child: Text(
                      "Freezer",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: deviceWidth * .08,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  )),

              //Meat Box
              InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MeatPage())),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/meat1.png'),
                          fit: BoxFit.fill,
                        ),
                        color: Colors.red[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    width: deviceWidth * .4,
                    height: deviceHeight * .241,
                    margin: EdgeInsets.only(
                        left: deviceWidth * .061, top: deviceHeight * .0180),
                    child: Center(
                        child: Text(
                      "Meat",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: deviceWidth * .08,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ))
            ]),

            // Second Row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Produce Box
                InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProducePage())),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/produce.png'),
                            fit: BoxFit.fill,
                          ),
                          color: Colors.green[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      margin: EdgeInsets.only(
                          left: deviceWidth * .054, top: deviceHeight * .05),
                      width: deviceWidth * .4,
                      height: deviceHeight * .241,
                      child: Center(
                          child: Text(
                        "Produce",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: deviceWidth * .08,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    )),

                //Pantry Box
                InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PantryPage())),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/can.png'),
                            fit: BoxFit.fill,
                          ),
                          color: Colors.brown[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      margin: EdgeInsets.only(
                          left: deviceWidth * .06, top: deviceHeight * .050),
                      width: deviceWidth * .4,
                      height: deviceHeight * .241,
                      child: Center(
                          child: Text(
                        "Pantry",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: deviceWidth * .08,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //All Food Box
                InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AllFoodPage())),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/bread.png'),
                            fit: BoxFit.fill,
                          ),
                          color: Colors.orange[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      margin: EdgeInsets.only(
                          left: deviceWidth * .053, top: deviceHeight * .053),
                      width: deviceWidth * .4,
                      height: deviceHeight * .241,
                      child: Center(
                          child: Text(
                        "AllFood",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: deviceWidth * .08,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    )),

                //Dairy Box
                InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DairyPage())),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/milk.png'),
                            fit: BoxFit.fill,
                          ),
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      margin: EdgeInsets.only(
                          left: deviceWidth * .062, top: deviceHeight * .055),
                      width: deviceWidth * .4,
                      height: deviceHeight * .241,
                      child: Center(
                          child: Text(
                        "Dairy",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: deviceWidth * .08,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                    ))
              ],
            )
          ],
      ),
    ),
        ));
  }
}
