import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:trial_app/user_data.dart';
import 'package:location/location.dart';

class listview extends StatefulWidget {
  // final AuthService _auth = AuthService();
  List BloodTypes;
  listview(this.BloodTypes);

  @override
  _listviewState createState() => _listviewState();
}

class _listviewState extends State<listview> {
  TextEditingController _searchController = TextEditingController();

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUserStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList(0, '');
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }

  searchResultsList(int i, String arg) {
    var showResults = [];

    if (i == 0) {
      if (_searchController.text != "") {
        for (var userSnapshot in _allResults) {
          var city = Data.fromSnapshot(userSnapshot).city.toLowerCase();
          if (city.startsWith(_searchController.text.toLowerCase())) {
            print(city);
            print(Data.fromSnapshot(userSnapshot).Name.toString());
            showResults.add(userSnapshot);
          }
        }
      } else {
        showResults = List.from(_allResults);
      }
    } else {
      for (var userSnapshot in _allResults) {
        var city = Data.fromSnapshot(userSnapshot).city.toLowerCase();
        if (city.startsWith(arg.toLowerCase())) {
          showResults.add(userSnapshot);
        }
      }
    }

    setState(() {
      _resultsList = showResults;
    });
  }

  getUserStreamSnapshots() async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('blood grp', whereIn: widget.BloodTypes)
        .get();

    setState(() {
      _allResults = data.docs;
    });
    searchResultsList(0, '');
    return 'complete';
  }



  var _address;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Positioned(
            top: 50,
            right: 15,
            left: 15,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 5.0,top:30),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search),
                                labelText: "Please enter your City",
                                labelStyle: TextStyle(color: Colors.grey),
                                prefixStyle: TextStyle(color: Colors.grey),
                                // contentPadding: EdgeInsets.all(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 0.05,
                    child: VerticalDivider(color: Colors.yellow),
                  ),
                  FloatingActionButton(
                    child: Icon(
                      Icons.my_location,
                      size: 30,
                    ),
                    onPressed: () async {
                      Location location = new Location();

                      bool _serviceEnabled;
                      PermissionStatus _permissionGranted;

                      _serviceEnabled = await location.serviceEnabled();
                      if (!_serviceEnabled) {
                        _serviceEnabled = await location.requestService();
                        if (!_serviceEnabled) {
                          return;
                        }
                      }

                      _permissionGranted = await location.hasPermission();
                      if (_permissionGranted == PermissionStatus.denied) {
                        _permissionGranted = await location.requestPermission();
                        if (_permissionGranted != PermissionStatus.granted) {
                          return;
                        }
                      }

                      var locationData = await location.getLocation();
                      print(locationData.latitude);
                      print(locationData.longitude);

                      _getAddress(locationData.latitude, locationData.longitude)
                          .then((value) {
                        setState(() {
                          _address = "${value.first.locality}";
                          searchResultsList(1, _address);
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _resultsList.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot users = _resultsList[index];
                return Card(
                  elevation: 8.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 14.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(width: 1.0, color: Colors.white24))),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Expanded(
                        child: Row(children: <Widget>[Text(users['full_name'],style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          SizedBox(width: 12),
                          Text('Age:',style: TextStyle(color: Colors.white),),
                          SizedBox(width: 5),
                          Text(users['age'],style: TextStyle(color: Colors.white),),
                          SizedBox(width: 12),
                          Text('Blood Type:',style: TextStyle(color: Colors.white),),
                          SizedBox(width: 5),
                          Text(users['blood grp'],style: TextStyle(color: Colors.white),),
                        ]),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                      subtitle: Row(children: <Widget>[

                        Text(users['phone'], style: TextStyle(color: Colors.white)),
                        SizedBox(width: 10),
                        Text(users['email'], style: TextStyle(color: Colors.white)),
                        SizedBox(width: 10),
                        Text(users['city'], style: TextStyle(color: Colors.white)),
                      ]),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}