import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  
  @override
  Widget build(BuildContext context) {
    return Container( child: _buildBody(context),);
  }
}

Widget _buildBody(BuildContext context){
  return StreamBuilder(
    stream: Firestore.instance.collection('users').document('rae77').snapshots(),
    builder: (context, snapshot) {
      final user= snapshot.data.data;
      final firstName = user['firstName'];
      final lastName =user['lastName'];
      final username = user['username'];
      if (!snapshot.hasData) return Text('LOADING');
      print(user);
      print(firstName);
      return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              //
            }),
        title: Text("User Profile"),
      ),
      body: Stack(
        children: <Widget>[

          _buildCoverImage(context),
          _buildProfileImage(),
          _buildInfo(context, firstName, lastName, username),
         
        ],
      ),
    );

    },
    
  );
}



Widget _buildCoverImage(context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.6,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://cdn-images-1.medium.com/max/800/0*qZS6sL0kKw5DVXPn.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

 Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://ichef.bbci.co.uk/news/660/cpsprodpb/12A6D/production/_110579367_finalpeople_immigration-nc.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
        
      ),
    );
  }

    Widget _buildInfo(context, firstName, lastName, username) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          
          children: <Widget>[Text(
           '$firstName $lastName',
           style: _nameTextStyle,
           ),Text(
          '$username',
         style: _nameTextStyle,
    )],));
  }

