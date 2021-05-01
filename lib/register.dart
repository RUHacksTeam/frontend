import 'package:flutter/material.dart';
import 'package:trial_app/uploadReport.dart';
import 'life_share.dart';
import 'package:email_validator/email_validator.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:csc_picker/csc_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _name;
  String _age;
  String _email;
  String _phoneno;
  String _bloodgrp;
  String country = " ";
  String state = " ";
  String city = " ";
  bool pressAttention = false;
  var locationData;

  // CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user

    await Firebase.initializeApp();

    // CollectionReference users = FirebaseFirestore.instance.collection('users');

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(_name)
        .set(
          {
            'full_name': _name, // John Doe
            'email': _email, // Stokes and Sons
            'age': _age, // 42
            'phone': _phoneno,
            'blood grp': _bloodgrp,
            'country': country,
            'state': state,
            'city': city,
            'lat': locationData.latitude,
            'long': locationData.longitude
          },
        )
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future navigateToFormScreen_2(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => FormScreen_2(_age, _bloodPressure,
        //     _bloodCholestrol, _maxHeartRate, _stressLevel),
        builder: (context) => UploadReport(_name),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Name can't be empty";
        }
        return null;
      },
      decoration: InputDecoration(labelText: "Full  Name"),
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildAgeField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: "Age"),
      validator: (value) {
        int temp_bp = int.tryParse(value);
        if (temp_bp == null || temp_bp <= 0) {
          return "Age must be greater than 0";
        } else if (temp_bp <= 18) {
          return "Donor's age must be greater than 18";
        }
        return null;
      },
      onSaved: (String value) {
        _age = value;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: "Enter email address"),
      validator: (val) =>
          !EmailValidator.validate(val, true) ? 'Not a valid email.' : null,
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPhoneNumField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: "Enter your phone number"),
      validator: (value) {
        int temp_hb = int.tryParse(value);
        if (temp_hb == null) {
          return "Please enter your phone number";
        }
        if (value.length < 10 || value.length > 10) {
          return "Invalid Phone Number";
        }
        return null;
      },
      onSaved: (String value) {
        _phoneno = value;
      },
    );
  }

  Widget _buildBloodGrpField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: "Please enter your blood type"),
      validator: (String value) {
        RegExp exp = RegExp(r"^(A|B|AB|O)[+-]$");
        if (!exp.hasMatch(value)) {
          return "Incorrect blood group";
        }
        if (value == null || value.isEmpty) {
          return "Please enter your blood group";
        }
      },
      onSaved: (String value) {
        _bloodgrp = value;
      },
    );
  }

  Widget _buildLocationField() {
    return CSCPicker(
      ///Enable disable state dropdown [OPTIONAL PARAMETER]
      showStates: true,

      /// Enable disable city drop down [OPTIONAL PARAMETER]
      showCities: true,

      ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
      flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

      // Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
      dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 0)),

      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
      disabledDropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 0)),

      // selected item style [OPTIONAL PARAMETER]
      selectedItemStyle: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),

      dropdownHeadingStyle: TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),

      dropdownItemStyle: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),

      dropdownDialogRadius: 10.0,

      searchBarRadius: 10.0,

      ///triggers once country selected in dropdown
      onCountryChanged: (value) {
        setState(() {
          ///store value in country variable
          if (value == null || value == " ") return "Please choose a country";
          country = value;
          print("\n\n Country is: " + country);
        });
      },

      ///triggers once state selected in dropdown
      onStateChanged: (value) {
        setState(() {
          ///store value in state variable
          if (value == null || value == " ") return "Please choose a state";
          state = value;
        });
      },

      ///triggers once city selected in dropdown
      onCityChanged: (value) {
        setState(() {
          ///store value in city variable
          if (value == null || value == " ") return "Please choose a city";
          city = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              // LifeShareScreen(),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Image(
                  image: AssetImage('logo.png'),
                  height: 100,
                  colorBlendMode: BlendMode.lighten,
                ),
              ),
              Text(
                "Welcome, please provide the",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                "folowing information",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          _buildNameField(),
                          SizedBox(height: 20),
                          _buildAgeField(),
                          SizedBox(height: 20),
                          _buildEmailField(),
                          SizedBox(height: 20),
                          _buildPhoneNumField(),
                          SizedBox(height: 20),
                          _buildBloodGrpField(),
                          SizedBox(height: 40),
                          _buildLocationField(),
                          SizedBox(height: 30),
                          RaisedButton(
                            color: Colors.blue,
                            padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                            child: Text(
                              "Next",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              _formKey.currentState.save();
                              // print(_age);
                              Location location = new Location();
                              locationData = await location.getLocation();
                              // store the data in firestore
                              addUser();

                              navigateToFormScreen_2(context);
                            },
                            // color: Colors.blue,
                            elevation: 10.0,
                            textColor: Colors.white,
                            splashColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
