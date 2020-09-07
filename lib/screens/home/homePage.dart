import 'dart:convert';
import 'dart:math';
import 'package:Trancity/screens/buses/busModel.dart';
import 'package:Trancity/screens/home/stationModel.dart';
import 'package:Trancity/screens/ticket/ticket.dart';
import 'package:http/http.dart' as http;
import 'package:Trancity/screens/style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TimeOfDay time;
  int selectedIndex = 0;
  String _valueFrom;
  List<Station> stations;
  String _valueTo;
  Future<List<Station>> _fromToFuture;
  Future<String> _reserveFuture;
  Future<List<Bus>> futureBuses;
  List<Bus> buses;
  String username;
  String id;
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
        stations = stationFromJson(response.body);
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

  Future<String> reserveTrip(
      String from, String to, String id, String bus, double price) async {
    try {
      final response = await http.post(
        passengerTrip,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'from': from.trim(),
          'to': to.trim(),
          'passengerID': id.trim(),
          'busID': bus.trim(),
          'price' : price
        }),
      );
      if (response.statusCode == 200) {
        showSnackBar("Your trip has been reserved succesfully", _scaffoldKey);
        return "";
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
    futureBuses = getBuses();
    time = TimeOfDay.now();
    SharedPreferences.getInstance().then((prefs) => {
          setState(() {
            username = prefs.getString('username');
            id = prefs.getString("_id");
          })
        });
    super.initState();
  }

  getStationName(String id) {
    for (var i = 0; i < stations.length; i++) {
      if (stations[i].id == id) {
        return stations[i].name;
      }
    }
  }

  getStationObj(String id) {
    for (var i = 0; i < stations.length; i++) {
      if (stations[i].id == id) {
        return stations[i];
      }
    }
  }

  getBusObj(String id) {
    for (var i = 0; i < buses.length; i++) {
      if (buses[i].id == id) {
        return buses[i];
      }
    }
  }

  String busUrl = 'http://192.168.43.59:8080/bus';

  Future<List<Bus>> getBuses() async {
    try {
      final response = await http.get(
        busUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        buses = busFromJson(response.body);
        return buses;
      } else {
        List<Bus> bus = [];
        return bus;
      }
    } catch (e) {
      List<Bus> bus = [];
      return bus;
    }
  }

  double radians(double degrees) {
    return (degrees * pi) / 180.0;
  }

  dynamic haversine(double lat1, double lon1, double lat2, double lon2) {
    // distance between latitudes and longitudes
    double dLat = radians(lat2 - lat1);
    double dLon = radians(lon2 - lon1);

    // convert to radians
    lat1 = radians(lat1);
    lat2 = radians(lat2);

    // apply formulae
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double rad = 6371;
    double c = 2 * asin(sqrt(a));
    return rad * c;
  }

  double distance = 0;
  String chooseCloseBus() {
    List<double> far = List<double>();
    int index;
    Station from = getStationObj(_valueFrom);
    for (var i = 0; i < buses.length; i++) {
      var result = haversine(
          double.parse(from.latitude),
          double.parse(from.longitude),
          double.parse(buses[i].lat),
          double.parse(buses[i].long));
      far.add(result);
    }
    distance = far[0];
    for (var i = 0; i < far.length; i++) {
      if (far[i] < distance) {
        distance = far[i];
      }
    }
    for (var i = 0; i < far.length; i++) {
      if (distance == far[i]) {
        index = i;
      }
    }
    return buses[index].id;
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  String travelDistance() {
    Station from = getStationObj(_valueFrom);
    Station to = getStationObj(_valueTo);
    var result = haversine(
        double.parse(from.latitude),
        double.parse(from.longitude),
        double.parse(to.latitude),
        double.parse(to.longitude));
    return roundDouble(result, 2).toString();
  }

  String travelTime() {
    var time = (double.parse(travelDistance()) * 10 / 36);
    return roundDouble(time, 2).toString();
  }

  String depretureTime() {
    Station from = getStationObj(_valueFrom);
    Bus bus = getBusObj(chooseCloseBus());
    double depDist = haversine(
        double.parse(from.latitude),
        double.parse(from.longitude),
        double.parse(bus.lat),
        double.parse(bus.long));
    double time = ((depDist) * 10 / 36);
    return roundDouble(time, 2).toString();
  }

  TimeOfDay fromTime() {
    if (double.parse(depretureTime()) < 1) {
      return time;
    } else {
      return time.replacing(minute: time.minute + int.parse(depretureTime()));
    }
  }

  TimeOfDay toTime() {
    if (double.parse(depretureTime()) < 1) {
      return time;
    } else {
      return fromTime()
          .replacing(minute: time.minute + int.parse(travelTime()));
    }
  }

  double price() {
    return roundDouble(double.parse(travelDistance()) * 2.5, 2);
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
                  setState(() {
                    _fromToFuture = getStations();
                    futureBuses = getBuses();
                    time = TimeOfDay.now();
                    _reserveFuture = null;
                  });
                },
              ),
            ),
          ],
        ),
        drawer: myDrawer(),
        body: Container(
          decoration: new BoxDecoration(color: backgroundColor1),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ticketAd(),
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
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: FutureBuilder<String>(
                            future: _reserveFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.none) {
                                return Text("");
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              } else if (snapshot.hasData) {
                                return Text("$snapshot.data");
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                      ),
                    )
                  : Text("Not Done"),
              ticket(),
            ],
          ),
        ),
      ),
    );
  }

// Drawer -------------------------------------------------------------
  Widget myDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo-large.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Welcome, $username",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: backgroundColor1,
            ),
          ),
          ListTile(
            leading: Icon(Icons.bus_alert),
            title: Text('buses'),
            onTap: () => Navigator.pushReplacementNamed(context, '/buses'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.confirmation_number),
            title: Text('Tickets'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Cards'),
            onTap: () => Navigator.pushReplacementNamed(context, '/cards'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Ticket())),
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
          Align(
            heightFactor: 40,
            child: Center(child: Text("All Rights Reserved to IU")),
          )
        ],
      ),
    );
  }

// from station ---------------------------------------------------------------------
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

// to station --------------------------------------------------------------------
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

// reverse button --------------------------------------------------------------------------
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

query(){
  return MediaQuery.of(context).size;
}
// ticket widget ----------------------------------------------------------------------------
  Widget ticket() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        height: query().height/1.7,
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.symmetric(vertical: 0.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[300],
            ),
            borderRadius: BorderRadius.circular(25.0)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Departure In:"),
                      SizedBox(
                        height: 5.0,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _valueFrom != null && _valueTo != null
                                  ? depretureTime()
                                  : "_ _ ",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            TextSpan(
                                text: "min",
                                style: Theme.of(context).textTheme.subtitle),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Travel Time: ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: _valueFrom != null && _valueTo != null
                                      ? travelTime()
                                      : "--",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45)),
                              TextSpan(
                                  text: " min",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Travel Distance: ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: _valueFrom != null && _valueTo != null
                                      ? travelDistance()
                                      : "--",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45)),
                              TextSpan(
                                  text: " KM",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                      ]),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    time.format(context),
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .apply(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.directions_bus,
                          color: Colors.black54,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          child: Text(
                            _valueFrom != null && _valueTo != null
                                ? fromTime().format(context)
                                : "--",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 3.0,
                          width: 5,
                        ),
                        Text(
                          _valueFrom != null
                              ? getStationName(_valueFrom)
                              : "choose Station",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_bus,
                          color: Colors.black54,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 9.0),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          child: Text(
                            _valueFrom != null && _valueTo != null
                                ? toTime().format(context)
                                : "--",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                          height: 3.0,
                        ),
                        Text(
                          _valueTo != null
                              ? getStationName(_valueTo)
                              : "Choose Station",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ],
                ),
                _valueFrom != null && _valueTo != null
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: RaisedButton.icon(
                            color: Colors.lightGreen,
                            icon: Icon(Icons.confirmation_number,
                                color: Colors.white),
                            onPressed: () => _reserveFuture = reserveTrip(
                                _valueFrom, _valueTo, id, chooseCloseBus(), price()),
                            label: Text(
                              _valueFrom != null && _valueTo != null
                                  ? price().toString() + ""
                                  : "--",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .apply(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Text("")
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget ticketAd(){
    return Container(
      width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    offset: Offset(0, 9),
                    color: Colors.lightGreen.withOpacity(.75),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Image.asset('assets/invoice.png'),
                  ),
                  SizedBox(width: 15.0),
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          "Buying tickets is now much more comfortable.",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "Buy a ticket now and get 50% discount.",
                          style: TextStyle(color: Colors.white70),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            );
  }
}
