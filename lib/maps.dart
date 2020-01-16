
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Map extends StatefulWidget {
  @override
  MapState createState() => MapState();
}

class MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }
    double zoomVal=5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
            }),
        title: Text("EVENTually"),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.search),
              onPressed: () {
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _buildBody(context),
        //   _buildGoogleMap(context),
          _zoomminusfunction(),
          _zoomplusfunction(),
        ],
      ),
    );
  }

 Widget _zoomminusfunction() {

    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
            icon: Icon(FontAwesomeIcons.searchMinus,color:Color(0xFF0097A7)),
            onPressed: () {
              zoomVal--;
             _minus( zoomVal);
            }),
    );
 }
 Widget _zoomplusfunction() {
   
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
            icon: Icon(FontAwesomeIcons.searchPlus,color:Color(0xFF0097A7)),
            onPressed: () {
              zoomVal++;
              _plus(zoomVal);
            }),
    );
 }

 Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(53.7949464, -1.5464861), zoom: zoomVal)));
  }
 Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(53.7949464, -1.5464861), zoom: zoomVal)));
  }

  
  Widget _buildGoogleMap(BuildContext context) {
   // print(longitude);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:  CameraPosition(target: LatLng(53.7949464, -1.5464861), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        // markers: {_buildMarker(context, longitude,latitude )}
      ),
    );
  }

Widget _buildBody(BuildContext context) {
  return StreamBuilder(
      stream: Firestore.instance
          .collection('attendees')
          .document('event1')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('...Loading');
        var keys = snapshot.data.data.keys.toList();
        var allMarker = {};
        for (var i = 0; i < keys.length; i++) {
          // var name = snapshot.data.data[keys[i]]['name'];
           var longitude = snapshot.data.data[keys[i]]['location'].longitude;
        var latitude = snapshot.data.data[keys[i]]['location'].latitude;
        print(longitude);
          allMarker[i] = (_buildMarker(context,longitude,latitude));
        }
       
        return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:  CameraPosition(target: LatLng(53.7949464, -1.5464861), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
         markers: allMarker.values.toSet()
      );
        //can I print this without connecthing this markerBuilder to anywhere in this code? didn't work.
       
      });
}




Marker _buildMarker(BuildContext context,longitude,latitude){
  return  Marker(
  markerId: MarkerId('northcoders'),
  position: LatLng(latitude, longitude),
  infoWindow: InfoWindow(title: 'Team EVENTually @ Northcoders, Platform'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueCyan,
  ),
);
}

Marker northcodersMarker = Marker(
  markerId: MarkerId('northcoders'),
  position: LatLng(53.7949464, -1.5464861),
  infoWindow: InfoWindow(title: 'Team EVENTually @ Northcoders, Platform'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueCyan,
  ),
);



Marker appleStoreMarker = Marker(
  markerId: MarkerId('appleStore'),
  position: LatLng(53.7967, -1.5450),
  infoWindow: InfoWindow(title: 'Apple store in Trinity Leeds'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueCyan,
  ),
);
}