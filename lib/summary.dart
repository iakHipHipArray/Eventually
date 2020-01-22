import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                children: <Widget>[Icon(Icons.location_on), Text('Date: TBC')],
              ),
            ),
            Card(
              child: Row(
                children: <Widget>[Icon(Icons.calendar_today), Text('Date: TBC')],
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
