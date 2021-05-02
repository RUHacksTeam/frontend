import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 5.0, top: 50),
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
          Expanded(
            child: ListView.builder(
              itemCount: _resultsList.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot users = _resultsList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0)),
                  elevation: 8.0,
                  margin: new EdgeInsets.all(10),
                  child: Container(
                    // decoration:
                    //     BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(
                                    width: 1.0, color: Colors.black))),
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 50,
                        ),
                      ),
                      title: Text(
                        "Name: " + users['full_name'],
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Age: ' +
                            users['age'] +
                            '   Blood Type: ' +
                            users['blood grp'] +
                            "\n"
                                "Phone: " +
                            users['phone'] +
                            "\n" +
                            "Email: " +
                            users['email'] +
                            "\n"
                                "City: " +
                            users['city'],
                        style: TextStyle(color: Colors.black),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
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
