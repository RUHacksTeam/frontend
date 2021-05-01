import 'package:flutter/material.dart';
import 'package:trial_app/life_share.dart';
import 'blood_type.dart';
import 'register.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LifeShareScreen(),
          Padding(
            padding: EdgeInsets.only(
                left: (MediaQuery.of(context).size.width / 10),
                top: MediaQuery.of(context).size.height / 1.5),
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    // LifeShareScreen(),
                    ElevatedButton(
                      child: Text("Register as A Donor",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.only(left: 50, right: 50)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.yellowAccent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red)))),
                      onPressed: () {
                        print('pressed');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Text("Find A Donor",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.only(left: 70, right: 70)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red)))),
                      onPressed: () {
                        print('pressed');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BloodType()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
