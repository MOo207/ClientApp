import 'dart:convert';
import 'package:Trancity/screens/home/stationModel.dart';
import 'package:http/http.dart' as http;
import 'package:Trancity/screens/style.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;
  String _valueFrom;
  String _valueTo;
  Future<List<Station>> _fromToFuture;
  Future<String> _reserveFuture;
  String username;
  int i = 0;

  String getStationUrl = 'http://192.168.43.59:8080/station';

  Future<List<Station>> getStations() async {
    try {
      final response = await http.get(
        getStationUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        List<Station> stations = stationFromJson(response.body);
        return stations;
      } else {
        List<Station> s;
        return s;
      }
    } catch (e) {
      print(e);
      List<Station> s;
      return s;
    }
  }

  String passengerTrip = 'http://192.168.43.59:8080/passenger/reserveTrip';

  Future<String> reserveTrip(String from, String to) async {
    try {
      final response = await http.post(
        passengerTrip,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'from': from, 'to': to}),
      );

      if (response.statusCode == 200) {
        showSnackBar("Your trip has been reserved succesfully", _scaffoldKey);
        return "1";
      } else {
        return "0";
      }
    } catch (e) {
      return e.toString();
    }
  }

  @override
  void initState() {
    _fromToFuture = getStations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: backgroundColor1,
        appBar: AppBar(
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
        drawer: MyDrawer(),
        body: Container(
          decoration: new BoxDecoration(color: backgroundColor1),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildFromUi(),
                            Divider(
                              height: 25,
                              color: Colors.black,
                              thickness: .7,
                            ),
                            buildToUi()
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      importExportButton()
                    ],
                  ),
                ),
              ),
              _reserveFuture != null && (_valueFrom != null && _valueTo != null)
                  ? Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: FutureBuilder<String>(
                            future: reserveTrip(_valueFrom, _valueTo),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.none) {
                                return Text("");
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              } else if (snapshot.hasData) {
                                return Text("");
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                      ),
                    )
                  : Text("Not Done"),
              Flexible(
                child: Center(
                  child: Align(
                    widthFactor: 1,
                    heightFactor: (height / 115),
                    alignment: Alignment.bottomCenter,
                    child: SimpleRoundButton(
                      backgroundColor: highlightColor,
                      buttonText: Text("Reserve Now"),
                      onPressed: () {
                        setState(() {
                          if (_valueFrom == null || _valueTo == null ) {
                            showSnackBar("you should pick source and destination points",_scaffoldKey);
                          }  else if (_valueFrom.compareTo(_valueTo) == 0) {
                            showSnackBar("source and destination cannot be the same!",_scaffoldKey);
                          } else {
                            _reserveFuture = reserveTrip(_valueFrom, _valueTo);
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFromUi() {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(.3),
            border: Border.all(color: Colors.blue, width: 3.0),
          ),
        ),
        SizedBox(width: 15.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "From",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: Colors.black38),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: FutureBuilder<List<Station>>(
                  future: _fromToFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      i++;
                      print("none " + i.toString());
                      return Text("start");
                    } else if (snapshot.hasError) {
                      i++;
                      print("error " + i.toString());
                      return Text("Try to connect then try!");
                    } else if (snapshot.hasData) {
                      i++;
                      print("data " + i.toString());
                      var stations = snapshot.data;
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: stations.map((Station station) {
                            return DropdownMenuItem<String>(
                              value: station.id,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    station.name,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _valueFrom = value;
                              print(_valueFrom);
                            });
                          },
                          hint: Text(
                            "select source station",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          elevation: 2,
                          isDense: true,
                          value: _valueFrom,
                          isExpanded: true,
                        ),
                      );
                    } else {
                      return Center(child: Text("Fetching..."));
                    }
                  }),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildToUi() {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.withOpacity(.3),
            border: Border.all(color: Colors.orange, width: 3.0),
          ),
        ),
        SizedBox(width: 15.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "To",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: Colors.black38),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: FutureBuilder<List<Station>>(
                  future: _fromToFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return Text("start");
                    } else if (snapshot.hasError) {
                      return Text("service is not available now!");
                    } else if (snapshot.hasData) {
                      var stations = snapshot.data;
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: stations.map((Station station) {
                            return DropdownMenuItem<String>(
                              value: station.id,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    station.name,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _valueTo = value;
                              print(_valueTo);
                            });
                          },
                          hint: Text(
                            "select destination station",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          elevation: 2,
                          isDense: true,
                          value: _valueTo,
                          isExpanded: true,
                        ),
                      );
                    } else {
                      return Center(child: Text("Fetching..."));
                    }
                  }),
            ),
          ],
        )
      ],
    );
  }

  Widget importExportButton() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xfff0f3f7), borderRadius: BorderRadius.circular(5.0)),
      child: IconButton(
        icon: Icon(
          Icons.import_export,
          color: Colors.black54,
        ),
        onPressed: () {
          setState(() {
            var temp;
            temp = _valueFrom;
            _valueFrom = _valueTo;
            _valueTo = temp;
          });
        },
      ),
    );
  }
}
