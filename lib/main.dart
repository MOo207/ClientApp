import 'dart:io';
import 'package:Trancity/screens/style.dart' as style;
import 'package:Trancity/screens/profile/loginPage.dart';
import 'package:Trancity/screens/profile/signup.dart';
import 'package:Trancity/screens/profile/welcomePage.dart';
import 'package:Trancity/services/addCard.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';



void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // style widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/root': (context) => WelcomePage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignUpPage(),
          '/home': (context) => HomePage(),
        },
      debugShowCheckedModeBanner: false,
      title: 'Trancity',
      theme: ThemeData(
          primaryColor: style.backgroundColor1,
          ),
      home: WelcomePage(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{ 
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final widgetOptions = [
    AddCard(),
    Text('sd')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trancity'),
      ),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), title: Text('Add Card')),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), title: Text('Add Card')),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: Colors.blueGrey,
        fixedColor: Colors.blue,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}