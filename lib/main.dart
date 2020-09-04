import 'dart:io';
import 'package:Trancity/screens/buses/buses.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Trancity/screens/cards/Cards.dart';
import 'package:Trancity/screens/home/homePage.dart';
import 'package:Trancity/screens/style.dart' as style;
import 'package:Trancity/screens/profile/loginPage.dart';
import 'package:Trancity/screens/profile/signup.dart';
import 'package:Trancity/screens/profile/welcomePage.dart';
// AIzaSyCmu_M1QUNSvub_68dIp4MckFUR8KPuU-Y
Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username');
  print(prefs.getString('_id'));
  print(username);
  runApp(MaterialApp(
    home: username == null ? WelcomePage() : HomePage(),
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/root': (context) => WelcomePage(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/login': (context) => LoginPage(),
      '/signup': (context) => SignUpPage(),
      '/home': (context) => HomePage(),
      '/cards': (context)=> Cards(),
      '/buses': (context)=> Buses(),
    },
    debugShowCheckedModeBanner: false,
    title: 'Trancity',
    theme: ThemeData(
      primaryColor: style.backgroundColor1,
    ),
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// 28.212942 34.735456
