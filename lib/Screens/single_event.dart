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
        title: Text('Routing App'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Yay the event $eventId is here!',
              style: TextStyle(fontSize: 50),
            ),
            Text(
              eventId,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}