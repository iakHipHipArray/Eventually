import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Map extends StatefulWidget {
  final String eventId;

  Map({
    Key key,
    @required this.eventId,
  }) : super(key: key);

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

  double zoomVal = 5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBody(context),
          _zoomminusfunction(),
          _zoomplusfunction(),
          createKey(),
        ],
      ),
    );
  }

  Widget createKey() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Centre'),
                  Icon(FontAwesomeIcons.solidSquare, color: Color(0xFF00FF00)),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Attendees'),
                  Icon(FontAwesomeIcons.solidSquare, color: Color(0xFF0096FF)),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Locations'),
                  Icon(FontAwesomeIcons.solidSquare, color: Color(0xFFFF005D)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchMinus, color: Color(0xFF0097A7)),
          onPressed: () {
            zoomVal--;
            _minus(zoomVal);
          }),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchPlus, color: Color(0xFF0097A7)),
          onPressed: () {
            zoomVal++;
            _plus(zoomVal);
          }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(53.7949464, -1.5464861), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(53.7949464, -1.5464861), zoom: zoomVal)));
  }

  Widget _buildBody(BuildContext context) {
    print('${widget.eventId} <- in BuildContext in maps');
    return StreamBuilder(
        stream: Firestore.instance
            .collection('attendees')
            .document('${widget.eventId}')
            .snapshots(),
        builder: (context, attendees) {
          if (!attendees.hasData) return Text('...Loading');
          return StreamBuilder(
              stream: Firestore.instance
                  .collection('locations')
                  .document('${widget.eventId}')
                  .snapshots(),
              builder: (context, locations) {
                if (!locations.hasData) return Text('...Loading');
                final map = BuildMap();
                final markers = map.makeMarkers(locations, attendees);
                return map.makeMap(_controller, markers);
              });
        });
  }
}

class BuildMap {
  makeMarkers(locations, attendees) {
    var markers = <MarkerId, Marker>{};
    final locationsData = locations.data.data;
    final locationsKeys = locationsData.keys.toList();
    for (var i = 0; i < locationsKeys.length; i++) {
      final hue = locationsKeys[i] == 'centre' ? 100.00 : 350.00;
      final MarkerId markerId = MarkerId(i.toString());
      final Marker marker = Marker(
          markerId: markerId,
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          position: LatLng(locationsData[locationsKeys[i]]['location'].latitude,
              locationsData[locationsKeys[i]]['location'].longitude));
      markers[markerId] = marker;
    }
    var allLats = [];
    var allLongs = [];
    final attendeesData = attendees.data.data;
    final attendeesKeys = attendeesData.keys.toList();
    for (var i = 0; i < attendeesKeys.length; i++) {
      if (attendeesData[attendeesKeys[i]]['attending']) {
        final MarkerId markerId =
            MarkerId((i + locationsKeys.length).toString());
        final Marker marker = Marker(
            markerId: markerId,
            icon: BitmapDescriptor.defaultMarkerWithHue(200),
            position: LatLng(
                attendeesData[attendeesKeys[i]]['location'].latitude,
                attendeesData[attendeesKeys[i]]['location'].longitude),
            infoWindow:
                InfoWindow(title: attendeesData[attendeesKeys[i]]['name']));
        allLats.add(attendeesData[attendeesKeys[i]]['location'].latitude);
        allLongs.add(attendeesData[attendeesKeys[i]]['location'].longitude);
        markers[markerId] = marker;
      }
    }
    final centre = findCentre(allLats, allLongs);
    postCentre(centre, locationsData['centre']['votes']);
    return markers;
  }

  makeMap(_controller, markers) {
    return GoogleMap(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          new Factory<OneSequenceGestureRecognizer>(
            () => new EagerGestureRecognizer(),
          ),
        ].toSet(),
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(53.7949464, -1.5464861), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values));
  }

  findCentre(lat, long) {
    final centreLat = lat.reduce((a, b) => a + b) / lat.length;
    final centreLong = long.reduce((a, b) => a + b) / long.length;
    return GeoPoint(centreLat, centreLong);
  }

  void postCentre(centre, votes) async {
    final data = {
      'centre': {'location': centre, 'votes': votes}
    };
    await Firestore.instance
        .collection('locations')
        .document('event1')
        .updateData(data);
  }
}
