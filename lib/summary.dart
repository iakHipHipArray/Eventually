import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          'Event Overview',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
        ),
        Card(
          child: Column(children: <Widget>[
            Text('My event'),
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
        )
      ],
    ));
  }
}
