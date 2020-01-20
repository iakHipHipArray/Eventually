import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

var eventDetails;

getEventInfo() {
  Firestore.instance
      .collection('events')
      .document('event1') // hardcoded atm
      .get()
      .then((event) => eventDetails = event);
}

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getEventInfo();
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          eventDetails['eventName'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
        ),
        Text(eventDetails['summary']),
        RaisedButton(
          child: Text('Confirm Event Details'),
          onPressed: () {}, // add functionality
        ),
        Image(
          image: NetworkImage(
              'https://ichef.bbci.co.uk/news/1024/branded_news/E34F/production/_104419185_bopper.jpg'), //Insert Map
        ),
        Card(
          child: Row(
            children: <Widget>[
              Icon(Icons.calendar_today),
              eventDetails['date'] == null
                  ? Text('Date: TBC')
                  : Text(eventDetails['date'])
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: _buildBody(context),
          ),
        )
      ],
    ));
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
