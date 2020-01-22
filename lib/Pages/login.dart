
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
            SizedBox(height: 40.0),
            Padding(
               padding: EdgeInsets.only(left: 40.0, right: 20.0, top: 10.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                     labelText: 'Username',
                     border: InputBorder.none,
                      hintText: "JohnDoe@example.com",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                ),
              ),
            ButtonBar(children: <Widget>[
FlatButton(
                  child: Text('Clear Username'),
                  onPressed: () {
                    _usernameController.clear();
                  },
                ),
            ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 40.0, right: 20.0, top: 10.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  ),
                obscureText: true,
              ),
            ),
             ButtonBar(children: <Widget>[
FlatButton(
                  child: Text('Clear Password'),
                  onPressed: () {
                    _passwordController.clear();
                  },
                ),
            ],
            ),
            ButtonBar(
              children: <Widget>[
                Container(
                   width: 320.0,
  height: 60.0,
  alignment: FractionalOffset.center,
  decoration: new BoxDecoration(
    color: const Color(0xFF3EBACE),
    borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
  ),
                  child: Text(
                    'Sign Up',
                    style: new TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.3,
    ),
                    ),
                ),
                            SizedBox(
              height: 12.0,
            ),
                Container(
                   width: 320.0,
  height: 60.0,
  alignment: FractionalOffset.center,
  decoration: new BoxDecoration(
      color: const Color(0xFF3EBACE),
    borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
  ),
                  child: GestureDetector(
                    onTap: () {
                    authHandler
                        .handleSignInEmail(
                            _usernameController.text, _passwordController.text)
                        .then((FirebaseUser user) {
                      Navigator.of(context).pushNamed(EventsPageRoute, arguments: 'Events List');
                    }).catchError((e) => print(e));
                  },
                                      child: Text(
                      'Login',
                      style: new TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.3,
    ),
                      ),
                  ),
                ),
                /* RaisedButton(
                  child: Container(
                    child: Text(
                      'LOGIN'),
                  ),
                  onPressed: () {
                    authHandler
                        .handleSignInEmail(
                            _usernameController.text, _passwordController.text)
                        .then((FirebaseUser user) {
                      Navigator.of(context).pushNamed(EventsPageRoute, arguments: 'Events List');
                    }).catchError((e) => print(e));
                  },

              ), */
               ],
                )
          ],
        ),
      ),
    );
  }
}
