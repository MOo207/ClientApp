import 'package:Trancity/screens/stations/stationModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class GetStations extends StatefulWidget {
  @override
  _GetStationsState createState() => _GetStationsState();
}

class _GetStationsState extends State<GetStations> {
  int selectedIndex = 0;
  Future<List<Station>> _future;

  String url = 'http://192.168.43.59:8080/station';

  Future<List<Station>> getStations() async {
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        List<Station> stations = stationFromJson(response.body);
        return stations;
      } else {
        List<Station> stations = [];
        return stations;
      }
    } catch (e) {
      return e.toList();
    }
  }

  @override
  void initState() {
    _future = getStations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    child: FutureBuilder<List<Station>>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.none) {
                            return Text("start");
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else if (snapshot.hasData) {
                            var station = snapshot.data;
                            return buildListView(station);
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

  refresh(){
    setState((){
    _future = null;
    _future = getStations();
    });
  }

  Widget buildListView(List<Station> station) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: station.length,
      itemBuilder: (context, int index) {
        return ListTile(
          leading: Icon(Icons.bus_alert),
          title: Text(station[index].id == null ? "not" : station[index].id),
          subtitle:
              Text(station[index].name == null ? "not" : station[index].name),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            onItemTapped(index, station);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Detail.a(
                          name: station[index].name,
                          maxCapacity: station[index].maxCapacity,
                        )));
          },
        );
      },
    );
  }

  dynamic onItemTapped(int index, List<Station> station) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class Detail extends StatelessWidget {
  Detail({
    this.id,
    this.name,
    this.cameras,
    this.longitude,
    this.latitude,
    this.maxCapacity,
  });

  Detail.a({
    this.name,
    this.maxCapacity,
  });

  String id;
  String name;
  List<Camera> cameras;
  String longitude;
  String latitude;
  int maxCapacity;

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
                      Text(name),
                      Text(maxCapacity.toString()),
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
