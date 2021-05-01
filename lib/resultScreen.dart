import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'life_share.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  Future navigateToFormScreen_2(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => FormScreen_2(_age, _bloodPressure,
        //     _bloodCholestrol, _maxHeartRate, _stressLevel),
        builder: (context) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              // LifeShareScreen(),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Image(
                  image: AssetImage('logo.png'),
                  height: 150,
                  colorBlendMode: BlendMode.lighten,
                ),
              ),
              SizedBox(height: 120),
              Icon(
                Icons.done_rounded,
                color: Colors.green,
                size: 120.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text(
                "Registration Succesful",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 80),
              RaisedButton(
                padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                child: Text(
                  "Go Home",
                  style: TextStyle(fontSize: 16.0),
                ),
                onPressed: () async {
                  navigateToFormScreen_2(context);
                },
                color: Colors.blue,
                elevation: 10.0,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
