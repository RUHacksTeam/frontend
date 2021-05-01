import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trial_app/user_data.dart';
import 'package:location/location.dart';

class FindDonor extends StatefulWidget {
  // final AuthService _auth = AuthService();
  List BloodTypes;
  FindDonor(this.BloodTypes);

  @override
  _FindDonorState createState() => _FindDonorState();
}

class _FindDonorState extends State<FindDonor> {
  TextEditingController _searchController = TextEditingController();

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  // List _BloodTypes = ['A+','O+'];

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
    print(_searchController.text);
  }

  Iterable markers = [];
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
      markers = [];
      createMarker();
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

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void createMarker() {
    Iterable _markers = [];
    _markers = Iterable.generate(
      _resultsList.length,
      (index) {
        return Marker(
          markerId: MarkerId(_resultsList[index]['long'].toString()),
          position: LatLng(
            _resultsList[index]['lat'],
            _resultsList[index]['long'],
          ),
          infoWindow: InfoWindow(
            title: "Name: " + _resultsList[index]['full_name'].toString(),
            snippet: "Age:" +
                _resultsList[index]['age'].toString() +
                "  Phone:" +
                _resultsList[index]['phone'].toString() +
                // "  Email: " +
                // _resultsList[index]['email'].toString() +
                "  Blood Grp: " +
                _resultsList[index]['blood grp'].toString(),
          ),
        );
      },
    );

    setState(() {
      markers = _markers;
    });
  }

  var _address;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // LifeShareScreen(),
          SizedBox(
            // width: 500, // or use fixed size like 200
            // height: 500,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(28.469782, 77.3094633),
                zoom: 13,
              ),
              onMapCreated: (GoogleMapController controller) {
                print("\n\n\n" + _allResults.toString());
                // createMarker();
                _controller.complete(controller);
              },
              markers: Set.from(markers),
            ),
          ),
          Positioned(
            top: 50,
            right: 15,
            left: 15,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Container(
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
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: _resultsList.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       DocumentSnapshot users = _resultsList[index];
          //       return ListTile(
          //         title: Text(users['full_name']),
          //         subtitle: Row(children: <Widget>[
          //           Text(users['blood grp']),
          //           SizedBox(width: 15),
          //           Text(users['city']),
          //         ]),
          //       );
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}
