import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

const _pinkHue = 350.0;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ice Creams FTW',
      home: const HomePage(title: 'Ice Cream Stores in SF'),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink[50],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({@required this.title});

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream _attendees;
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _attendees = Firestore.instance
          .collection('attendees')
          .document('event1')
          .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: _attendees,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}}'));
          if (!snapshot.hasData) return Center(child: Text('Loading...'));

          return Column(
            children: [
              Flexible(
                flex: 2,
                child: StoreMap(
                  documents: snapshot,
                  initialPosition: const LatLng(37.7786, -122.4375),
                  mapController: _mapController,
                ),
              ),
              
            ],
          );
        },
      ),
    );
  }
}

class StoreMap extends StatelessWidget {
  const StoreMap({
    Key key,
    @required this.documents,
    @required this.initialPosition,
    @required this.mapController,
  }) : super(key: key);

  final documents;
  final LatLng initialPosition;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 12,
      ),
      markers: documents.data.data.forEach((k,v) => Marker(markerId: MarkerId(v['ID'].toString()),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(
            v['location'].latitude,
            v['location'].longitude
          ),
          infoWindow: InfoWindow(
            title:v['name'],
            snippet: 'FATTTTHHHHHEERRRRRRRRRR!'
          )
           )).toList(),
      onMapCreated: (mapController) {
        this.mapController.complete(mapController);
      },
    );
  }
}

class StoreList extends StatelessWidget {
  const StoreList({
    Key key,
    @required this.documents,
    @required this.mapController,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (builder, index) {
        final document = documents[index];
        return StoreListTile(
          document: document,
          mapController: mapController,
        );
      },
    );
  }
}

class StoreListTile extends StatefulWidget {
  const StoreListTile({
    Key key,
    @required this.document,
    @required this.mapController,
  }) : super(key: key);

  final DocumentSnapshot document;
  final Completer<GoogleMapController> mapController;

  @override
  _StoreListTileState createState() => _StoreListTileState();
}

class _StoreListTileState extends State<StoreListTile> {
  String _placePhotoUrl = '';
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.document['name']),
      subtitle: Text(widget.document['address']),
      leading: Container(
        child: _placePhotoUrl.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(_placePhotoUrl),
              )
            : Container(),
        width: 60,
        height: 60,
      ),
      onTap: () async {
        final controller = await widget.mapController.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                widget.document['location'].latitude,
                widget.document['location'].longitude,
              ),
              zoom: 16,
            ),
          ),
        );
      },
    );
  }
}
