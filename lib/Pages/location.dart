import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class LocationGetter extends StatelessWidget {
  void _displayCurrentLocation() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   print('Current location lat long ' + location.latitude.toString() + " - " + location.longitude.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Hello Location",
        home: Scaffold(
            body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(""),
                FlatButton(
                  child: Text("Choose your current location",
                      style: TextStyle(color: Colors.white)),
                  color: Colors.blue,
                  onPressed: () {
                    _displayCurrentLocation();
                  },
                )
              ]),
        )));
  }
}
