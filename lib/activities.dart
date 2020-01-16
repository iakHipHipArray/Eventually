import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Activity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          'Activity overview',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
        ),
        Card(
          child: Column(children: <Widget>[
            Text('My event'),
            Text(
                '술마시자 애두랑 히히히ㅣㅎ히 신나라 큐큐큨큐큐'),
          ]),
        ),
        Image(
          image: NetworkImage(
              'https://ichef.bbci.co.uk/news/660/cpsprodpb/9E04/production/_100525404_gettyimages-475705672-2.jpg'),
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
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder(
    stream: Firestore.instance
        .collection('activities')
        .document('event1')
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Text('LOADING');
      var keys = snapshot.data.data.keys.toList();
      var activity= snapshot.data.data[keys[0]]['name'].toString();
      var description = snapshot.data.data[keys[0]]['body'].toString();
      print (activity);
      print (description);
     
      return ListView.builder(
          itemExtent: 80.0,
          itemCount: keys.length,
          itemBuilder: (context, index) => Card(
                child: Row(
                  children: <Widget>[
                    Text(activity),
                    Text(description)
                  ],
                ),
              ));
    },
  );
}
