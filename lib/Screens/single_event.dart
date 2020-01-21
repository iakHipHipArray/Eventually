import 'package:flutter/material.dart';

class SingleEvent extends StatelessWidget {
  final String eventId;

  SingleEvent({
    Key key,
    @required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event ID: $eventId'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'This is the page for $eventId',
              style: TextStyle(fontSize: 50),
            ),
            Text(
              'Welcome!',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}