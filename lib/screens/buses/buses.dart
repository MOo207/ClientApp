import 'package:Trancity/screens/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'busModel.dart';

class Buses extends StatefulWidget {
  @override
  _BusesState createState() => _BusesState();
}

class _BusesState extends State<Buses> {
  int selectedIndex = 0;
  Future<List<Bus>> _future;

  String url = 'http://192.168.43.59:8080/bus';

  Future<List<Bus>> getBuses() async {
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        List<Bus> bus = busFromJson(response.body);
        return bus;
      } else {
        List<Bus> bus = [];
        return bus;
      }
    } catch (e) {
      List<Bus> bus = [];
        return bus;
    }
  }

double radians(double degrees){ 
  return (degrees * pi) / 180.0;
}

  double haversine(double lat1, double lon1, double lat2, double lon2) 
    { 
        // distance between latitudes and longitudes 
        double dLat = radians(lat2 - lat1); 
        double dLon = radians(lon2 - lon1); 
  
        // convert to radians 
        lat1 = radians(lat1); 
        lat2 = radians(lat2); 
  
        // apply formulae 
        double a = pow(sin(dLat / 2), 2) +  
                   pow(sin(dLon / 2), 2) *  
                   cos(lat1) *  
                   cos(lat2); 
        double rad = 6371; 
        double c = 2 * asin(sqrt(a)); 
        return rad * c; 
    } 

  @override
  void initState() {
    _future = getBuses();
    super.initState();
  }

  Widget buildListView(List<Bus> bus) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: bus.length,
      itemBuilder: (context, int index) {
        return ListTile(
          leading: Icon(Icons.bus_alert),
          title: Text(bus[index].id == null ? "not" : bus[index].id),
          subtitle: Text(bus[index].id == null ? "not" : bus[index].id),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            onItemTapped(index, bus);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Detail.a(
                          id: bus[index].id,
                          maxCap: bus[index].maxCap,
                        )));
          },
        );
      },
    );
  }

  dynamic onItemTapped(int index, List<Bus> bus) {
    setState(() {
      selectedIndex = index;
    });
    }

@override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor1,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () => Navigator.pushReplacementNamed(context, "/home")
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                   print(haversine(27.33,33.65 , 29.4,34.3));
                },
              ),
            ),
          ],
        ),
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _future == null
              ? Text("No station")
              : Container(
                  width: width,
                  height: height -400,
                  child: Card(
                    child: FutureBuilder<List<Bus>>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.none) {
                            return Text("start");
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else if (snapshot.hasData) {
                            var buses = snapshot.data;
                            return buildListView(buses);
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ),
        ],
      ),
    );
  }
  
}

class Detail extends StatelessWidget {
  Detail({
    this.id,
    this.status,
    this.maxCap,
    this.currentCap,
    this.lat,
    this.long,
    this.source,
    this.destination,
    this.v,
  });

  Detail.a({this.id, this.maxCap});

  String id;
  String status;
  int maxCap;
  int currentCap;
  String lat;
  String long;
  String source;
  String destination;
  int v;
  var appBar = AppBar();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var high = appBar.preferredSize.height;
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                height: height - high - 32,
                width: width,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(id),
                      Text(maxCap.toString()),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
