import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final document;
  final dates;
  final locations;
  DropDown(this.document,this.dates,this.locations);
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String dropDownDate = '02-02-2020';
  String dropDownLocation = 'Sheffield';
  @override
  Widget build(BuildContext context) {
              print(widget.dates);
    return Column(
      children: <Widget>[
        new DropdownButton<String>(
          value: dropDownDate,
          items: widget.dates
            .map<DropdownMenuItem<String>>((value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }
          ).toList(),
          onChanged: (String newValue) {
            setState(() {
              dropDownDate = newValue;
            });
          }
        ),
        new DropdownButton<String>(
          value: dropDownLocation,
          items: widget.locations
            .map<DropdownMenuItem<String>>((value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }
          ).toList(),
          onChanged: (String newValue) {
            setState(() {
              dropDownLocation = newValue;
            });
          }
        ),
        FlatButton(
          child: Text('FINALIZE'),
          onPressed: () {
            final data = {'date':dropDownDate,'location':dropDownLocation};
            Firestore.instance.collection('events').document(widget.document).updateData(data);
            Navigator.pop(context);
          },

        )
      ],
    );
  }
}

class Summary extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('events')
        .document('event1')
        .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('LOADING');
        final event = snapshot.data.data;
        final date = event['date'] == null ? 'Date: TBC' : event['date'];
        final location = event['location'] == null ? 'Location: TBC' : event['location'];
        // final image = event['image'] ? event['image'] : '';
        // print(image);
        return Container(
            child: Column(
          children: <Widget>[
            Stack(
              children:<Widget>[ 
                // Image(
                //   image: NetworkImage(
                //     image
                //   ),
                // ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        event['eventName'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
                      ),
                      Text(event['summary'])
                    ]
                  ),
                )
              ],
            ),
            Card(
              child: Row(
                children: <Widget>[Icon(Icons.location_on), Text(location)],
              ),
            ),
            Card(
              child: Row(
                children: <Widget>[Icon(Icons.calendar_today), Text(date)],
              ),
            ),
            Expanded(
              child: Container(
                child: _buildBody(context),
              ),
            ),
            if(event['date'] == null) finalizeButton(context)
            
          ],
        ));
      }
    );
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder(
    stream: Firestore.instance
        .collection('attendees')
        .document('event1')
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Text('LOADING');
      var keys = snapshot.data.data.keys.toList();
      return ListView.builder(
          itemExtent: 80.0,
          itemCount: keys.length,
          itemBuilder: (context, index) => Card(
                child: Row(
                  children: <Widget>[
                    Text(snapshot.data.data[keys[index]]['name']),
                    snapshot.data.data[keys[index]]['attending']
                        ? Icon(Icons.check)
                        : Icon(Icons.clear)
                  ],
                ),
              ));
    },
  );
}

Widget finalizeButton(BuildContext context) {
  finalizeEvent(BuildContext context) async {
  final locations = ['Sheffield','Leeds', 'Slough','Edinburgh'];
  final dates = ['02-02-2020','21-02-2020','01-03-2020'];
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Finalize Details'),
        content: DropDown('event1',dates,locations),
      );
    });
  }
  return RaisedButton(
    child: Text('Finalize'),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    onPressed: () {
      finalizeEvent(context);
    }
  );
}