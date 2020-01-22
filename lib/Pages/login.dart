
import 'package:EVENTually/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'
import 'package:EVENTually/Pages/registration.dart';
import 'package:EVENTually/services/authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final authHandler = new Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text('EVENTually'),
              ],
            ),
            SizedBox(height: 120.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(filled: true, labelText: 'Username'),
            ),
            SizedBox(
              height: 12.0,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(filled: true, labelText: 'Password'),
              obscureText: true,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('SIGN UP'),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return UserRegistration();
                    }));
                  },
                ),
                RaisedButton(
                  child: Text('LOGIN'),
                  onPressed: () {
                    authHandler
                        .handleSignInEmail(
                            _usernameController.text, _passwordController.text)
                        .then((FirebaseUser user) {
                      Navigator.of(context).pushNamed(EventsPageRoute, arguments: 'Events List');
                    }).catchError((e) => print(e));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
