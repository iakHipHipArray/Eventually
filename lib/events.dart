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
        return _buildList(context, snapshot.data.documents);
      });
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList());
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);

  return Padding(
    key: ValueKey(record.eventName),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
        child: Column(
      children: <Widget>[
        Text(record.eventName),
        SizedBox(height: 10),
        Text(record.summary),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            record.finalDate != null
                ? Text('Date: $record.finalDate')
                : Text('Date: TBC'),
            Spacer(),
            record.finalLocation != null
                ? Text('Location: $record.finalDate')
                : Text('Location: TBC')
          ],
        )
      ],
    )),
  );
}

class Record {
  final String eventName;
  final String summary;
  final finalDate;
  final finalLocation;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['eventName'] != null),
        assert(map['summary'] != null),
        eventName = map['eventName'],
        summary = map['summary'],
        finalDate = map['finalDate'],
        finalLocation = map['finalLocation'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$eventName:$summary>";
}
