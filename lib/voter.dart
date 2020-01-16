import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Voter extends StatefulWidget {
  @override
  _VoterState createState() => new _VoterState();
}

class _VoterState extends State<Voter> {
  bool _isButtonDisabled;

  @override
  void initState() {
    _isButtonDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('locations')
          .document('event1')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('0');
        return _buildVoter(context, snapshot.data.data);
      },
    );
  }

  Widget _buildVoter(BuildContext context, snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
            child: Icon(
              (Icons.keyboard_arrow_up),
            ),
            onTap: () {
              _isButtonDisabled
                  ? null
                  : Firestore.instance
                      .collection('locations')
                      .document('event1')
                      .updateData({
                      'location1.votes': snapshot['location1']['votes'] + 1
                    });
              setState(() {
                _isButtonDisabled = true;
              });
            }),
        Text(snapshot['location1']['votes'].toString())
      ],
    );
  }
}
