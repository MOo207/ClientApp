import 'dart:convert';

import 'package:Trancity/screens/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Cards extends StatefulWidget {
  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String addCardUrl = 'http://192.168.43.59:8080/passenger/addPassengerCard';
  String getCardUrl = 'http://192.168.43.59:8080/passenger/getPassengerCard';
  String removeCardUrl =
      "http://192.168.43.59:8080/passenger/removePassengerCard";

  Future futureCard;
  String cardCode;
  String id;
  final codeController = TextEditingController();
  int i = 0;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) => {
          setState(() {
            cardCode = prefs.getString('cardCode');
            id = prefs.getString('_id');
            print(prefs.getString("cardCode"));
          })
        });
    futureCard = null;
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    codeController.dispose();
    super.dispose();
  }

  Widget div() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: foregroundColor, width: 0.5, style: BorderStyle.solid),
        ),
      ),
    );
  }

  Widget _field(String hint, TextEditingController myController) {
    return TextField(
      expands: false,
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
        addCardUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'_id': _id, 'code': code}),
      );
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 5));
        print(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('cardCode', code);
        setState(() {
          cardCode = prefs.getString("cardCode");
        });
        showSnackBar("Card added successfully!", _scaffoldKey);
        return "done";
      } else {
        print(response.body);
        showSnackBar("Card not added successfully!" , _scaffoldKey);
        return "not completed";
      }
    } catch (e) {
      showSnackBar(e.toString() , _scaffoldKey);
      return e.toString();
    }
  }

  Future<String> removeCard(String passengerID) async {
    try {
      final http.Response response = await http.put(
        removeCardUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'passengerID': passengerID}),
      );
      if (response.statusCode == 200) {
        showSnackBar("Card removed successfully!", _scaffoldKey);
        return "done";
      } else {
        showSnackBar("Card not removed" , _scaffoldKey);
        return "not completed";
      }
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: backgroundColor1,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, "/home"),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        body: cardCode == null ? buildAddCardUi() : buildRemoveCardUi());
  }

  Widget buildRemoveCardUi() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Your Card Code is: " + cardCode,
              style: TextStyle(color: Colors.white, fontSize: 20)),
          SizedBox(height: 30),
          submitButton("Remove Card", determine)
        ],
      ),
    ));
  }

  Widget buildAddCardUi() {
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 50),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 15 ),
          width: MediaQuery.of(context).size.width,
          height: height / 19,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: foregroundColor,
                  width: 0.5,
                  style: BorderStyle.solid),
            ),
          ),
          padding: const EdgeInsets.only(left: 0.0, right: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.alternate_email,
                color: foregroundColor,
              ),
              Expanded(child: _field("Code", codeController)),
            ],
          ),
        ),
        SizedBox(height: 20),
        FutureBuilder<String>(
            future: futureCard,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                i++;
                print("none");
                return Text("none card: " + i.toString());
              } else if (snapshot.hasError) {
                i++;
                print(snapshot.error);
                return Text("error card: " + i.toString());
              } else if (snapshot.hasData) {
                i++;
                print("data card: " + snapshot.data);
                return Text(snapshot.data + i.toString(),
                    style: TextStyle(color: Colors.white));
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: highlightColor,
                    semanticsLabel: "Loading",
                  )
                );
              }
            }),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Center(child: submitButton("AddCard", determine)),
        ),
      ],
    );
  }

  Future<void> submit() async {
    String code = codeController.text.trim();
    futureCard = addCard(id, code);
  }

  Future<void> remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    futureCard = removeCard(id);
    prefs.remove("cardCode");
    setState(() {
      cardCode = null;
    });
  }

  void determine() {
    if (cardCode == null) {
      submit();
    } else {
      remove();
    }
  }
}
