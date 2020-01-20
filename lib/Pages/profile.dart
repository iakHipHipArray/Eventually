import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  
  @override
  Widget build(BuildContext context) {
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
          _buildFullName()
        ],
      ),
    );
  }
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

    Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      "Narae Kim",
      style: _nameTextStyle,
    );
  }

