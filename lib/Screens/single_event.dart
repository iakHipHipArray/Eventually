import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleEvent extends StatelessWidget {
  final String eventId;

  SingleEvent({
    Key key,
    @required this.eventId,
  }) : super(key: key);

  getSingleEvent() {
    return Firestore.instance
        .collection('events')
        .document('$eventId')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getSingleEvent(),
      builder: (context, snapshot) {
        final singleEventData = snapshot.data.data;
        final singleEventKeys = singleEventData.keys.toList();
        final attendees = singleEventData['attendees'];
        final eventName = singleEventData['eventName'];
        final summary = singleEventData['summary'];
        final date = singleEventData['date'];

    print('ID in SingleEvent -> $eventId');
        print('singleEventKeys: $singleEventKeys');
        print('singleEventInfo -> $attendees');
        print("singleEventDate -> $date");
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return MaterialApp(
            home: DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(
                        text: 'Summary',
                      ),
                      Tab(text: 'Activities'),
                      Tab(
                        text: 'Location',
                      ),
                      Tab(
                        text: 'Dates',
                      )
                    ],
                  ),
                  title: Text('$eventName: $eventId'),
                ),
                body: TabBarView(
                  children: <Widget>[
                    Text('$summary', ),
                    Text('Activities'),
                    Text('Location'),
                    Text('$date')
                  ],
                ),
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}