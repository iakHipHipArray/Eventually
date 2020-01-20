import 'package:EVENTually/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  List dates = [];
  List _attendees;
  Position _currentPosition;
  String _currentAddress;
  var id = new DateTime.now().millisecondsSinceEpoch.toString();

  delete(dynamic obj) {
    setState(() {
      dates.remove(obj);
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
      _getAddressFromLatLng();
    });
  }

  _getAddressFromLatLng() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  postLocation() {
    Firestore.instance.collection('locations').document(id).setData({
      'location1': {
        'location':
            new GeoPoint(_currentPosition.latitude, _currentPosition.longitude),
        'votes': 0
      }
    });
  }

  postEventDetails() {
    Firestore.instance.collection('events').document(id).setData({
      'eventName': _titleController.text,
      'summary': _summaryController.text,
      'attendees': _attendees,
      'ID': id
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

  @override
  Widget build(BuildContext context) {
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
              dataSource: [
                {
                  "display": "Ryan",
                  "value": "ryan1214",
                },
                {
                  "display": "Robin",
                  "value": "rmpillar",
                },
                {
                  "display": "Narae",
                  "value": "rae77",
                },
                {
                  "display": "Inshirah",
                  "value": "bob742",
                }
              ],
              textField: 'display',
              valueField: 'value',
              filterable: true,
              required: true,
              value: null,
              change: (values) {
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
                if (_currentPosition != null) Text(_currentAddress),
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
