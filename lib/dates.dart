import 'package:EVENTually/voter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatesTab extends StatelessWidget {
  final String eventId;

  DatesTab(this.eventId,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBody(context,eventId),
    );
  }
}

Widget _buildBody(BuildContext context,eventId) {
  return StreamBuilder(
    stream:
        Firestore.instance.collection('dates').document(eventId).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Text('Loading...');
      final keys = snapshot.data.data.keys.toList();
      return ListView.builder(
        itemExtent: 80.0,
        itemCount: keys.length,
        itemBuilder: (context, index) => Card(
          child: Row(
              children: <Widget>[
                Container(
                  width: 200,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Start: ' +
                        snapshot.data.data[keys[index]]['start']
                      ),
                      Text('Finish: ' +
                          snapshot.data.data[keys[index]]['end'])
                    ],
                  ),
                ),
                Text('Attendees: '),
                Voter('dates', 'event1', keys[index])
              ]
              ),
        ),
      );
    },
  );
}
