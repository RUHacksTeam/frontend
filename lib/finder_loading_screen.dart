import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trial_app/find_donor.dart';

import 'bottom_app_bar/app.dart';
import 'list_view.dart';

class findloadingscreen extends StatefulWidget {
  List BloodTypes;
  findloadingscreen(this.BloodTypes);

  @override
  _findloadingscreenState createState() => _findloadingscreenState();
}

class _findloadingscreenState extends State<findloadingscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // builder: (context) => bottom_nav_bar(widget.BloodTypes),
          builder: (context) => App(widget.BloodTypes),
        ));
  }

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.network(
                'https://www.clipartmax.com/png/middle/149-1497912_blood-donation-up-donor-darah-logo-png.png',
                width: 100,
                height: 80,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              "Finding Verified Donors",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.red,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator(
              backgroundColor: Colors.black,
              strokeWidth: 1,
            )
          ],
        ),
      ),
    );
  }
}
