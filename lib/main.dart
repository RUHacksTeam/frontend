import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:trial_app/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new HomeScreen(),
        title: Text(
          'PlasmaShare',
          style: TextStyle(
            color: Colors.red,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        image: new Image(
          image: AssetImage('logo.png'),
          height: 300,
          colorBlendMode: BlendMode.lighten,
        ),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.red,
      ),
    );
  }
}
