import 'dart:convert';

import 'package:Trancity/screens/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  String url = 'http://192.168.43.65:8080/passenger/addPassengerCard';
  Future _future;
  final _idController = TextEditingController();
  final codeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _idController.dispose();
    codeController.dispose();
    super.dispose();
  }

  Widget div(){
    return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: foregroundColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              );
  }

 Widget _field(String hint, TextEditingController myController) {
    return TextField(
      controller: myController,
       cursorColor: highlightColor,
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(color: foregroundColor),
      ),
    );
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
      backgroundColor: backgroundColor1,
        body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.centerLeft,
            end: new Alignment(
                1.0, 0.0), // 10% of the width, so there are ten blinds.
            colors: [
              backgroundColor1,
              backgroundColor2
            ], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
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
                 
                   _field("id",_idController),
                  SizedBox(height: 50),
                  _field("code",codeController ),
                  SizedBox(height: 20),
                  submitButton("AddCard", ()=> _future = addCard(_idController.text.trim(), codeController.text.trim())),
                  FutureBuilder<String>(
                      future: _future,
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
