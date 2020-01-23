import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          'Event Overview',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38,
           letterSpacing: 1.5,),
        ),
        Card(
          child: Column(children: <Widget>[
            Text('My event',
                style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
            ),
            Text(
                'asdfgfdsfgfdsdfg dfghfdfsg jdfkg dfkg jdfkjgh ekjfhg djfhg dkjfgh dfjh '),
          ]),
        ),
        Image(
          image: NetworkImage(
              'https://ichef.bbci.co.uk/news/1024/branded_news/E34F/production/_104419185_bopper.jpg'),
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
                    Text(
                      snapshot.data.data[keys[index]]['name'],
                      ),
                    snapshot.data.data[keys[index]]['attending']
                        ? Icon(Icons.check, color: Colors.green[600],
                        )
                        : Icon(Icons.clear, color: Colors.red[800],
                        ),
                  ],
                ),
              ));
    },
  );
}
