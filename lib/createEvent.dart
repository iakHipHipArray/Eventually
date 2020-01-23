import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  List dates = [];
  List _attendees;
  List _friends = [];
  Position _currentPosition;
  String _currentAddress;
  var id = new DateTime.now().millisecondsSinceEpoch.toString();
  var count = 0;
  var _index = 1;

  delete(dynamic obj) {
    setState(() {
      dates.remove(obj);
    });
  }

  getFriends() {
    Firestore.instance
        .collection('friends')
        .document('ryan1214')
        .get()
        .then((friends) {
      friends.data.forEach((k, v) => {
            _friends.add({'display': v, 'value': k})
          });
      count++;
    });
  }

  getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      getAddress().then((data) => _currentPosition = data);
    });
  }

  // _getAddressFromLatLng() async {
  //   final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  //   try {
  //     List<Placemark> p = await geolocator.placemarkFromCoordinates(
  //         _currentPosition.latitude, _currentPosition.longitude);

  //     Placemark place = p[0];

  //     setState(() {
  //       _currentAddress = "${place.postalCode}, ${place.country}";
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  getAddress() async {
    final coordinates =
        new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first.addressLine;
  }

  postLocation() {
    Firestore.instance.collection('locations').document(id).setData({
      'location1': {
        'location':
            new GeoPoint(_currentPosition.latitude, _currentPosition.longitude),
        'votes': 0
      },
      'centre': {'location': new GeoPoint(53.900341, -1.363163), 'votes': 0}
    });
  }

  postEventDetails() {
    Firestore.instance.collection('events').document(id).setData({
      'eventName': _titleController.text,
      'summary': _summaryController.text,
      'attendees': _attendees,
      'ID': id,
      'date': null,
      'location': null,
      'image': null
    });
  }

  postDates() {
    Firestore.instance.collection('dates').document(id).setData({
      'date1': {'start': dates[0]['start'], 'end': dates[0]['end'], 'votes': 1}
    });
    for (var i = 1; i < dates.length; i++) {
      Firestore.instance.collection('dates').document(id).updateData({
        'date${i + 1}': {
          'start': dates[i]['start'],
          'end': dates[i]['end'],
          'votes': 1
        }
      });
    }
  }

  sendNotifications() {
    for (var i = 0; i < _attendees.length; i++) {
      Firestore.instance
          .collection('notifications')
          .document(_attendees[i])
          .updateData({
        '$id': {
          'ID': id,
          'username': _attendees[i],
          'body':
              'You have been invited to an event by Ryan1214', // change to say who made event (hardcoded atm)
          'receivedAt': new DateTime.now().millisecondsSinceEpoch
        }
      });
    }
  }

  postAttendees() {
    Firestore.instance.collection('attendees').document(id).setData({
      'ryan1214': {
        // hardcoded to ryan1214
        'ID': 1,
        'attending': true,
        'location':
            new GeoPoint(_currentPosition.latitude, _currentPosition.longitude),
        'name': 'Ryan'
      }
    });
    for (var i = 0; i < _attendees.length; i++) {
      Firestore.instance.collection('attendees').document(id).updateData({
        _attendees[i]: {
          'ID': null,
          'attending': false,
          'location': null,
          'name': _friends[i]['display']
        }
      });
    }
  }

  postActivities() {
    Firestore.instance.collection('activities').document(id).setData({});
  }

  @override
  Widget build(BuildContext context) {
    if (count < 1) {
      getFriends();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text('EVENTually'),
              ],
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(filled: true, labelText: 'Title'),
            ),
            SizedBox(
              height: 30.0,
            ),
            TextField(
              controller: _summaryController,
              decoration:
                  InputDecoration(filled: true, labelText: 'Description'),
            ),
            SizedBox(
              height: 30.0,
            ),
            MultiSelect(
              autovalidate: false,
              titleText: 'Add Friends',
              validator: (value) {
                if (value == null) {
                  return 'Please select one or more friends(s)';
                }
              },
              errorText: 'Please select one or more friends(s)',
              dataSource: _friends,
              textField: 'display',
              valueField: 'value',
              filterable: true,
              required: true,
              value: null,
              change: (values) {
                print(values);
                setState(() {
                  _attendees = values;
                });
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            Column(
              children: <Widget>[
                _currentPosition != null ? Text(_currentAddress) : Text(''),
                RaisedButton(
                  child: Text('Get my Location'),
                  onPressed: () {
                    getCurrentLocation();
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemExtent: 80.0,
                  itemCount: dates.length,
                  itemBuilder: (context, index) =>
                      _buildListItem(context, dates[index])),
            ),
            RaisedButton(
              child: Text('Pick a date'),
              onPressed: () {
                DateRangePicker.showDatePicker(
                        context: context,
                        initialFirstDate: DateTime.now(),
                        initialLastDate:
                            (new DateTime.now()).add(new Duration(days: 7)),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030))
                    .then((date) {
                  setState(() {
                    dates.insert(dates.length, {
                      'start': new DateFormat('dd-MM-yyyy')
                          .format(date[0])
                          .toString(),
                      'end': new DateFormat('dd-MM-yyyy')
                          .format(date[1])
                          .toString()
                    });
                  });
                });
              },
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    //navigate back
                  },
                ),
                RaisedButton(
                  child: Text('CREATE'),
                  onPressed: () {
                    postLocation();
                    postEventDetails();
                    postDates();
                    postAttendees();
                    sendNotifications();
                    postActivities();
                    //navigate to singleEvent.dart
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, data) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(data['start']),
          Text(data['end']),
          RaisedButton(
            child: Text('Remove'),
            onPressed: () => delete(data),
          ),
        ],
      ),
    );
  }
}
