import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Trancity/screens/style.dart' as style;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../style.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String url = 'http://192.168.43.59:8080/passenger/login';
  Future _futureLogin;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<String> login(String username, String password) async {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', username);
      String id = jsonDecode(response.body)['_id'];
      prefs.setString('_id', id);
    showSnackBar("Logged in successfully", _scaffoldKey);
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);
      return "done";
    } else {
      showSnackBar("Logged in fails", _scaffoldKey);
      return "not completed";
    }
  }

  Widget _loginButton(Future future) {
    return FlatButton(
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30.0)
      //     ),
      color: style.highlightColor,
      onPressed: () {
        setState(() {
          future = login(
              usernameController.text.trim(), passwordController.text.trim());
        });
      },
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
                "LOGIN",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: style.foregroundColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forgetPasswordButton() {
    return FlatButton(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      color: Colors.transparent,
      onPressed: () => {},
      child: Text(
        "Forgot your password?",
        style: TextStyle(color: style.foregroundColor.withOpacity(0.5)),
      ),
    );
  }

  Widget _goSignup() {
    return FlatButton(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      color: Colors.transparent,
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUpPage())),
      child: Text(
        "Don't have an account? Create One",
        style: TextStyle(color: style.foregroundColor.withOpacity(0.5)),
      ),
    );
  }

  Widget _field(TextEditingController myController, bool isPass, String hint) {
    return TextField(
      obscureText: isPass,
      controller: myController,
      cursorColor: style.highlightColor,
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(color: style.foregroundColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.centerLeft,
            end: new Alignment(
                1.0, 0.0), // 10% of the width, so there are ten blinds.
            colors: [
              style.backgroundColor1,
              style.backgroundColor2
            ], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 150.0, bottom: 50.0),
              child: Center(
                child: new Column(
                  children: <Widget>[
                    Container(
                      height: 128.0,
                      width: 128.0,
                      child: new Text(
                        "",
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(image: style.logo)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Text(
                        "Neom Trancity",
                        style: TextStyle(color: style.foregroundColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: height / 19,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: style.foregroundColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(
                      Icons.alternate_email,
                      color: style.foregroundColor,
                    ),
                  ),
                  new Expanded(
                      child: _field(usernameController, false, 'Username')),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: style.foregroundColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(
                      Icons.lock_open,
                      color: style.foregroundColor,
                    ),
                  ),
                  Expanded(child: _field(passwordController, true, 'Password')),
                ],
              ),
            ),
            FutureBuilder<String>(
                future: _futureLogin,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Text("");
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return Text(snapshot.data);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(child: _loginButton(_futureLogin)),
                ],
              ),
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(child: _forgetPasswordButton()),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: Divider(),
            ),
            Flexible(
              child: new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    left: 40.0, right: 40.0, top: 10.0, bottom: 20.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(child: _goSignup()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
