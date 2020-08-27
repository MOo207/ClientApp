import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

  final Color backgroundColor1 = Color(0xFF444152);
  final Color backgroundColor2 = Color(0xFF6f6c7d);
  final Color highlightColor = Color(0xffe0a28f);
  final Color foregroundColor = Colors.white;
  final AssetImage logo = AssetImage('assets/images/logo-large.png');

 void showSnackBar(String message, GlobalKey<ScaffoldState> _scaffoldKey) {
    final snackBar = SnackBar(
      backgroundColor: highlightColor,
      content: Text(
        message,
        style: TextStyle(
          color: foregroundColor,
        ),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

Widget submitButton(String text,Function function) {
    return FlatButton(
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30.0)
      //     ),
      color: highlightColor,
      onPressed: function,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: foregroundColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
    }

    
class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Image.asset('images/logo.png',
                // width: 80,
                // height: 80,),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "",
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: backgroundColor1,
            ),
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Cards'),
            onTap: () => Navigator.pushReplacementNamed(context, '/cards'),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy & Policy'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushReplacementNamed(context, '/root');
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

class SimpleRoundButton extends StatelessWidget {

  final Color backgroundColor;
  final Text buttonText;
  final Color textColor;
  final Function onPressed;

  SimpleRoundButton({
    this.backgroundColor,
    this.buttonText,
    this.textColor,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              splashColor: this.backgroundColor,
              color: this.backgroundColor,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: buttonText,
                  ),
                ],
              ),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}