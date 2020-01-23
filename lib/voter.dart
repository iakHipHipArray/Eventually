import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Voter extends StatefulWidget {
  final collection;
  final document;
  final item;

  Voter(this.collection, this.document, this.item);
  
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
    print(widget.document);
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection(widget.collection)
          .document(widget.document)
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
              _isButtonDisabled ? (Icons.favorite) : (Icons.favorite_border),
            color: Color(0xFFd32f2f)
            ),
            onTap: () {
              _isButtonDisabled
                  ? null
                  : Firestore.instance
                      .collection(widget.collection)
                      .document(widget.document)
                      .updateData({
                      '${widget.item}.votes': snapshot['${widget.item}']['votes'] + 1
                    });
              setState(() {
                _isButtonDisabled = true;
              });
            }),
        Text(snapshot['${widget.item}']['votes'].toString())
      ],
    );
  }
}