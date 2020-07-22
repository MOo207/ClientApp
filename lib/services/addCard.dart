import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  String url = 'http://192.168.43.65:8080/pass/combine';
  Future _futureLogin;
  final _idController = TextEditingController();
  final codeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _idController.dispose();
    codeController.dispose();
    super.dispose();
  }

  Widget _entryField(String title, TextEditingController myController,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: myController,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("_id", _idController),
        _entryField("code", codeController),
      ],
    );
  }

  Widget _submitButton(Future future) {
    return RaisedButton(
        child: Text('Submit'),
        onPressed: () {
          setState(() {
            future =
                addCard(_idController.text.trim(), codeController.text.trim());
          });
        });
  }

  Future<String> addCard(String _id, String code) async {
    try {
      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'_id': _id, 'code': code}),
      );
      if (response.body == "1") {
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Response"),
              content: new Text(
                  'Response body is ${response.body} operation done successfully'),
            ));
        return "done";
      } else {
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Notice"),
              content: new Text(response.body),
            ));
        return "not completed";
      }
    } catch (e) {
      return showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Error"),
              content: new Text(e.toString()),
            ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  _submitButton(_futureLogin),
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
                  // _divider(),
                  // skip(),
                  SizedBox(height: height * .055),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
