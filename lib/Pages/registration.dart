import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EVENTually/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:EVENTually/main.dart';
import 'package:geolocator/geolocator.dart';

class UserRegistration extends StatefulWidget {
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  final _firstNameController= TextEditingController();
  final _lastNameController= TextEditingController();
  final _userNameController= TextEditingController();
  final authHandler = new Auth();
  Position _currentPosition;
  String _currentAddress;

  

  _createData(){
  DocumentReference db= Firestore.instance.collection('users').document(_userNameController.text);
  Map<String, dynamic> newUser={
    'firstName' :_firstNameController.text,
    'lastName':_lastNameController.text,
    'username':_userNameController.text,
    'email': _emailEditingController.text,
    'location': new GeoPoint(_currentPosition.latitude, _currentPosition.longitude),
  };
  print(newUser);
  db.setData(newUser).whenComplete((){
    print('new user added');});
  }

  getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    });
  }

  _getAddressFromLatLng() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    autofocus: false,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    controller: _userNameController,
                    decoration: InputDecoration(
                        labelText: "Username",
                        hintText: "Username",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.blue,
                                style: BorderStyle.solid))),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    autofocus: false,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    controller: _firstNameController,
                    decoration: InputDecoration(
                        labelText: "First Name",
                        hintText: "First Name",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.blue,
                                style: BorderStyle.solid))),
                    
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    autofocus: false,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    controller: _lastNameController,
                    decoration: InputDecoration(
                        labelText: "Last Name",
                        hintText: "Last Name",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.blue,
                                style: BorderStyle.solid))),
                  
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: <Widget>[
                      _currentPosition != null? Text(_currentAddress):Text(''),
                        RaisedButton(
                          child: Text('Get my Location'),
                          onPressed: () {
                          getCurrentLocation();
                          },
                         ),
                    ],
                   ),                  
                  SizedBox(
                    height: 30,
                  ),
                         TextField(
                    autofocus: false,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailEditingController,
                    decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.blue,
                                style: BorderStyle.solid))),
                    
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    autofocus: false,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: _passwordEditingController,
                    decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.blue,
                                style: BorderStyle.solid))),
                    
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[                    
                    RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          _firstNameController.clear();
                          _lastNameController.clear();
                          _userNameController.clear();
                          _emailEditingController.clear();
                          _passwordEditingController.clear();
                          setState(() {
                             _currentPosition=null;
                          });
                         
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white,
                        )),
                    ),
                    
                    RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          authHandler.handleSignUp(
                            _emailEditingController.text, _passwordEditingController.text)
                            .whenComplete(() {
                              _createData();
                            }).then((FirebaseUser user) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new HomePage()));
                    }).catchError((e) => print(e));
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white,
                        ))
                    )
                  ],
                )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}