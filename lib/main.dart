import 'dart:io';
import 'package:Trancity/screens/cards/addCard.dart';
import 'package:Trancity/screens/stations/getStations.dart';
import 'package:Trancity/screens/style.dart' as style;
import 'package:Trancity/screens/profile/loginPage.dart';
import 'package:Trancity/screens/profile/signup.dart';
import 'package:Trancity/screens/profile/welcomePage.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

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
    GetStations(),
    AddCard()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){},
          child: Icon(Icons.track_changes),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        opacity: .2,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(16)), //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.red,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.access_time,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.access_time,
                color: Colors.deepPurple,
              ),
              title: Text("Logs")),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.folder_open,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.folder_open,
                color: Colors.indigo,
              ),
              title: Text("Folders")),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.menu,
                color: Colors.green,
              ),
              title: Text("Menu"))
        ],
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}