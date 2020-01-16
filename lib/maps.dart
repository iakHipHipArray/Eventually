
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Map extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MapState();
  }
}

class MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();

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

Widget _buildBody(BuildContext context) {
  
  return StreamBuilder(
      stream: Firestore.instance
          .collection('attendees')
          .document('event1')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('...Loading');
        var markers = <MarkerId, Marker>{};
        final data = snapshot.data.data;
        final keys = data.keys.toList();
        for (var i = 0; i < keys.length; i++) {
          final MarkerId markerId = MarkerId(data[keys[i]]['ID'].toString());
          final Marker marker = Marker(
            markerId: markerId,
            position: LatLng(data[keys[i]]['location'].latitude, data[keys[i]]['location'].longitude)
          );
          markers[markerId] = marker;
        }

        return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:  CameraPosition(target: LatLng(53.7949464, -1.5464861), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
         markers: Set<Marker>.of(markers.values)
         
      );
      });
}

}