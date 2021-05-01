import 'package:flutter/material.dart';

class LifeShareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              left: 10, top: MediaQuery.of(context).size.height / 11),
          child: Stack(
            children: <Widget>[
              Image(
                image: AssetImage('logo.png'),
                height: 400,
                colorBlendMode: BlendMode.lighten,
              ),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(200, 300, 0, 0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Plasma",
                          style: TextStyle(fontSize: 30, color: Colors.red),
                        ),
                        Text(
                          "Share",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "COVID: Plasma Donor App",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
