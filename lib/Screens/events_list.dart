import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() {
    return _EventsPageState();
  }
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Events'),
        ),
        body: _buildBody(context));
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('events')
          .where('attendees', arrayContains: 'ryan1214')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('...Loading');
        return ListView.builder(
          itemExtent: 100.0,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, snapshot.data.documents[index]),
        );
      });
}

Widget _buildListItem(BuildContext context, data) {
  return Padding(
    key: ValueKey(data.data['eventName']),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
        child: Column(
      children: <Widget>[
        Text(data.data['eventName']),
        SizedBox(height: 10),
        Text(data.data['summary']),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            data.data['finalDate'] != null
                ? Text('Date: $data.finalDate')
                : Text('Date: TBC'),
            Spacer(),
            data.data['finalLocation'] != null
                ? Text('Location: $data.finalDate')
                : Text('Location: TBC')
          ],
        )
      ],
    )),
  );
}
