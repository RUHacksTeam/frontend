import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trial_app/life_share.dart';
import 'httpRequest.dart';
import 'main.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'resultScreen.dart';

class UploadReport extends StatefulWidget {
  String name;
  UploadReport(this.name);

  @override
  _UploadReportState createState() => _UploadReportState();
}

class _UploadReportState extends State<UploadReport> {
  String errorName = " ";
  File _image;
  var pickedFile;
  String image_loc = '';

  final picker = ImagePicker();

  Future getImage() async {
    pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        image_loc = pickedFile.path;
        image_loc = image_loc.split("/").last;
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadFile() async {
    File file = File(pickedFile.path);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('image/img.jpg') // can change it to png too
          .putFile(file);
    } catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  Future navigateToFormScreen_2(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => FormScreen_2(_age, _bloodPressure,
        //     _bloodCholestrol, _maxHeartRate, _stressLevel),
        builder: (context) => Result(),
      ),
    );
  }

  Widget error() {
    return Text("The name on the form and the submitted name are not the same");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // LifeShareScreen(),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Image(
              image: AssetImage('logo.png'),
              height: 150,
              colorBlendMode: BlendMode.lighten,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Please upload an image of your positive COVID report",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
            child: IconButton(
              icon: Icon(Icons.upload_file),
              iconSize: 50,
              color: Colors.blue,
              onPressed: () async {
                await getImage();
                await uploadFile();
              },
            ),
          ),
          Text(
            image_loc,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  errorName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                  splashColor: Colors.grey,
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () async {
                    var i = 0;
                    setState(() {
                      errorName = "    Loading....\n Please Wait";
                      i = 1;
                    });
                    // await uploadFile();
                    String choose_url =
                        'https://peaceful-crane-312411.et.r.appspot.com/';
                    Uri url = Uri.parse(choose_url);
                    await GetData(url);
                    await GetData(url);
                    await GetData(url);

                    choose_url += '/api';
                    url = Uri.parse(choose_url);
                    String Data = await GetData(url);
                    print(Data);
                    var DecodedData = jsonDecode(Data);

                    print(DecodedData['email']);
                    print(DecodedData['name']);
                    print(widget.name);

                    if (DecodedData['name'].toString().toLowerCase() !=
                        widget.name.toString().toLowerCase()) {
                      setState(() {
                        i = 0;
                        errorName =
                            "The name on the file and the name provided in the form are not the same";
                      });
                      return;
                    } else if (i == 0) {
                      setState(() {
                        errorName = " ";
                      });
                    }

                    String username = 'ruhacktemp@gmail.com';
                    String password = 'ruhacktemp';

                    String receiver = 'rishikoul2@gmail.com';

                    final smtpServer = gmail(username, password);
                    // Use the SmtpServer class to configure an SMTP server:
                    // final smtpServer = SmtpServer('smtp.domain.com');
                    // See the named arguments of SmtpServer for further configuration
                    // options.

                    // Create our message.
                    final message = Message()
                      ..from = Address(username, 'Rishi Koul')
                      ..recipients.add(receiver)
                      ..attachments.add(FileAttachment(_image))
                      ..subject =
                          'Verification For Plasma Donation :: ${DateTime.now()}'
                      ..text = 'Hi,\n' +
                          DecodedData['name'] +
                          ' has requested to register as a eligible plasma donor on our app. Below are the details of the patient.\n Please verify if the user is eligible for donating plasma.\n\n';

                    try {
                      final sendReport = await send(message, smtpServer);
                      print('Message sent: ' +
                          sendReport.toString() +
                          "to " +
                          receiver);
                    } on MailerException catch (e) {
                      print('Message not sent.');
                      for (var p in e.problems) {
                        print('Problem: ${p.code}: ${p.msg}');
                      }
                    }

                    navigateToFormScreen_2(context);
                  },
                  color: Colors.blue,
                  elevation: 10.0,
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
          // _image == null ? Text('No image selected.') : Image.file(_image),
        ],
      ),
    );
  }
}
