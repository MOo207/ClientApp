import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'placeholder_widget.dart';
import 'package:http/http.dart' as http;

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({
    Key key,

    /// If set, enable the FusedLocationProvider on Android
    @required this.androidFusedLocation,
  }) : super(key: key);

  final bool androidFusedLocation;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  Position _lastKnownPosition;
  Position _currentPosition; 

  String url = 'http://192.168.43.59:8080/bus/track/5f1cc0fee4b1bb00ec5e06af';

  @override
  void initState() {
    super.initState();
    _initLastKnownLocation();
    _initCurrentLocation();
    Timer.periodic(Duration(seconds: 5), (Timer t) => trackBus());
  }



  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _lastKnownPosition = null;
      _currentPosition = null;
    });

    _initLastKnownLocation().then((_) => _initCurrentLocation());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initLastKnownLocation() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = !widget.androidFusedLocation;
      position = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _lastKnownPosition = position;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = !widget.androidFusedLocation
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).then((position) {
        if (mounted) {
          setState(() => _currentPosition = position);
        }
      }).catchError((e) {
        //
      });
  }

   Future trackBus() async {
    try {
      var lat;
      var long;
      if(_lastKnownPosition == null || _lastKnownPosition == _currentPosition){
        return "";
        } else if(_currentPosition == null){
           lat = _lastKnownPosition.latitude.toString();
          long = _lastKnownPosition.longitude.toString();
        } else{
          lat = _currentPosition.latitude.toString();
          long = _currentPosition.longitude.toString();
        }
      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'lat': lat, 'long': long}),
      );
      if (response.statusCode == 200) {
        print(lat + long);
        return "done";
      } else {
        print("not done");
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
    return FutureBuilder<GeolocationStatus>(
        future: Geolocator().checkGeolocationPermissionStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == GeolocationStatus.denied) {
            return const PlaceholderWidget('Access to location denied',
                'Allow access to the location services for this App using the device settings.');
          }

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: Text(
                    _fusedLocationNote(),
                    textAlign: TextAlign.center,
                  ),
                ),
                PlaceholderWidget(
                    'Last known location:', _lastKnownPosition.toString()),
                PlaceholderWidget(
                    'Current location:', _currentPosition.toString()),
              ],
            ),
          );
        });
  }

  String _fusedLocationNote() {
    if (widget.androidFusedLocation) {
      return 'Geolocator is using the Android FusedLocationProvider. This requires Google Play Services to be installed on the target device.';
    }

    return 'Geolocator is using the raw location manager classes shipped with the operating system.';
  }
}