import 'package:EVENTually/activities.dart';
import 'package:EVENTually/dates.dart';
import 'package:EVENTually/maps.dart';
import 'package:EVENTually/summary.dart';
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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  title: Text('$eventName'),
                  // '$eventId
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),

                  bottom: TabBar(
                    indicatorColor: Theme.of(context).accentColor,
                    tabs: <Widget>[
                      Tab(text: 'Summary', icon: Icon(Icons.adjust)),
                      Tab(
                        text: 'Location',
                        icon: Icon(Icons.location_city),
                      ),
                      Tab(
                        text: 'Dates',
                        icon: Icon(Icons.calendar_view_day),
                      ),
                      Tab(text: 'Activities', icon: Icon(Icons.local_activity)),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    Summary(eventId),
                    Map(eventId),
                    DatesTab(eventId),
                    Activity(eventId),
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
