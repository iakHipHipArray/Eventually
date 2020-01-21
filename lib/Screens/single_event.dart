import 'package:EVENTually/dates.dart';
import 'package:EVENTually/maps.dart';
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
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print(snapshot.data.data);
          final singleEventData = snapshot.data.data;
          // final singleEventKeys = singleEventData.keys.toList();
          // final attendees = singleEventData['attendees'];
          final eventName = singleEventData['eventName'];
          final summary = singleEventData['summary'];
          // final date = singleEventData['date'];

          // print('ID in SingleEvent -> $eventId');
          // print('singleEventKeys: $singleEventKeys');
          // print('singleEventInfo -> $attendees');
          // print("singleEventDate -> $date");
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('$eventId: $eventName'),
                  leading: Icon(Icons.menu),
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.search), onPressed: () => {}),
                    IconButton(icon: Icon(Icons.more_vert), onPressed: () => {})
                  ],
                  bottom: TabBar(
                    indicatorColor: Colors.yellow,
                    tabs: <Widget>[
                      Tab(text: 'Summary', icon: Icon(Icons.adjust)),
                      Tab(text: 'Activities', icon: Icon(Icons.local_activity)),
                      Tab(
                        text: 'Location',
                        icon: Icon(Icons.location_city),
                      ),
                      Tab(
                        text: 'Dates',
                        icon: Icon(Icons.calendar_view_day),
                      )
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    Text(
                      '$summary',
                    ),
                    Text('Activities'),
                    Map(eventId: eventId),
                    DatesTab(),
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
