import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Voter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder(
    stream: Firestore.instance
        .collection('locations')
        .document('event1')
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Text('0');
      return _buildVoter(context, snapshot.data.data);
    },
  );
}

Widget _buildVoter(BuildContext context, snapshot) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      GestureDetector(
          child: Icon(
            (Icons.keyboard_arrow_up),
          ),
          onTap: () {
            Firestore.instance
                .collection('locations')
                .document('event1')
                .updateData(
                    {'location1.votes': snapshot['location1']['votes'] + 1});
          }),
      Text(snapshot['location1']['votes'].toString())
    ],
  );
}
