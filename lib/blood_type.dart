import 'package:flutter/material.dart';
import 'package:trial_app/find_donor.dart';
import 'package:trial_app/life_share.dart';

class BloodType extends StatefulWidget {
  @override
  _BloodTypeState createState() => _BloodTypeState();
}

class _BloodTypeState extends State<BloodType> {
  int selectedCard = -1;
  List _BloodTypes = [];
  String BloodType = '';

  List<int> _selectedIndexList = [];

  final List<String> _labels = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image(
                image: AssetImage('logo.png'),
                height: 120,
                colorBlendMode: BlendMode.lighten,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: (MediaQuery.of(context).size.width / 40),
                    top: MediaQuery.of(context).size.height / 40),
                child: Column(children: <Widget>[
                  Text(
                    'Please pick your',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'blood type',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: 8,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2.2),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              // ontap of each card, set the defined int to the grid view index
                              selectedCard = index;
                              BloodType = _labels[index];
                              print(BloodType);

                              if (index == 0) {
                                _BloodTypes.clear();
                                _BloodTypes.add('A+');
                                _BloodTypes.add('A-');
                                _BloodTypes.add('O+');
                                _BloodTypes.add('O-');
                                _selectedIndexList.clear();
                                _selectedIndexList.add(0);
                                _selectedIndexList.add(1);
                                _selectedIndexList.add(6);
                                _selectedIndexList.add(7);
                              }
                              if (index == 1) {
                                _BloodTypes.clear();
                                _BloodTypes.add('A-');
                                _BloodTypes.add('O-');
                                _selectedIndexList.clear();
                                _selectedIndexList.add(1);
                                _selectedIndexList.add(7);
                              }
                              if (index == 2) {
                                _BloodTypes.clear();
                                _BloodTypes.add('B+');
                                _BloodTypes.add('B-');
                                _BloodTypes.add('O+');
                                _BloodTypes.add('O-');
                                _selectedIndexList.clear();
                                _selectedIndexList.add(2);
                                _selectedIndexList.add(3);
                                _selectedIndexList.add(7);
                              }
                              if (index == 3) {
                                _BloodTypes.clear();
                                _BloodTypes.add('B-');
                                _BloodTypes.add('O-');
                                _selectedIndexList.clear();
                                _selectedIndexList.add(3);
                                _selectedIndexList.add(7);
                              }
                              if (index == 4) {
                                _BloodTypes.clear();
                                _BloodTypes.add('A+');
                                _BloodTypes.add('A-');
                                _BloodTypes.add('B+');
                                _BloodTypes.add('B-');
                                _BloodTypes.add('AB-');
                                _BloodTypes.add('AB+');
                                _BloodTypes.add('O+');
                                _BloodTypes.add('O-');
                                _selectedIndexList.clear();
                                _selectedIndexList.add(0);
                                _selectedIndexList.add(1);
                                _selectedIndexList.add(2);
                                _selectedIndexList.add(3);
                                _selectedIndexList.add(4);
                                _selectedIndexList.add(5);
                                _selectedIndexList.add(6);
                                _selectedIndexList.add(7);
                              }
                              if (index == 5) {
                                _BloodTypes.clear();
                                _BloodTypes.add('A-');
                                _BloodTypes.add('B-');
                                _BloodTypes.add('AB-');
                                _BloodTypes.add('O-');
                                _selectedIndexList.clear();
                                _selectedIndexList.add(1);
                                _selectedIndexList.add(3);
                                _selectedIndexList.add(5);
                                _selectedIndexList.add(7);
                              }
                              if (index == 6) {
                                _BloodTypes.clear();
                                _BloodTypes.add('O-');
                                _BloodTypes.add('O+');
                                _selectedIndexList.clear();
                                _selectedIndexList.add(6);
                                _selectedIndexList.add(7);
                              }
                              if (index == 7) {
                                _BloodTypes.clear();
                                _BloodTypes.add('O-');
                                _selectedIndexList.clear();
                                _selectedIndexList.add(7);
                              }
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            elevation: 3,
                            // check if the index is equal to the selected Card integer
                            color: selectedCard == index
                                ? Colors.red[700]
                                : Colors.white,
                            child: Container(
                              height: 220,
                              width: 200,
                              child: Center(
                                child: Text(
                                  _labels[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Image.network(
                                            'https://thumbs.dreamstime.com/b/blood-logo-vector-icon-illustration-design-blood-logo-vector-137009729.jpg',
                                            width: 70,
                                          ),
                                          SizedBox(width: 0),
                                          Text(
                                            BloodType,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'can receive from',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  GridView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: _BloodTypes.length,
                                      gridDelegate:
                                          new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width /
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2),
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Card(
                                            elevation: 5,
                                            // check if the index is equal to the selected Card integer
                                            color: Colors.red[700],
                                            child: Container(
                                              height: 200,
                                              width: 200,
                                              child: Center(
                                                child: Text(
                                                  _BloodTypes[index],
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Text(
                        "Submit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () {
                      print('pressed');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) =>  MyLocation(),
                          builder: (context) => FindDonor(_BloodTypes),
                        ),
                      );
                    },
                  ),
                ])),
          ],
        ),
      ]),
    );
  }
}
