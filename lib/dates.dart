import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBody(context),
    );
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder(
    stream:
        Firestore.instance.collection('dates').document('event1').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Text('Loading...');
      final keys = snapshot.data.data.keys.toList();
      return ListView.builder(
        itemExtent: 80.0,
        itemCount: keys.length,
        itemBuilder: (context, index) => Card(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Start: ' +
                        new DateFormat('dd-MM-yyy')
                            .format(snapshot.data.data[keys[index]]['start']
                                .toDate())
                            .toString()),
                    Text('Finish: ' +
                        new DateFormat('dd-MM-yyy')
                            .format(
                                snapshot.data.data[keys[index]]['end'].toDate())
                            .toString())
                  ],
                ),
                Text('Attendees: ' +
                    snapshot.data.data[keys[index]]['votes'].toString())
              ]),
        ),
      );
    },
  );
}
