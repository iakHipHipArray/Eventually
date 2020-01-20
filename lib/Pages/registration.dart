import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EVENTually/services/authentication.dart';

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


  _createData(){
  DocumentReference db= Firestore.instance.collection('users').document(_userNameController.text);
  Map<String, String> newUser={
    'firstName' :_firstNameController.text,
    'lastName':_lastNameController.text,
    'username':_userNameController.text,
  };
  print(newUser);
  db.setData(newUser).whenComplete(()=>{
    print('new user added')});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
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
                  TextField(
                    autofocus: false,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    controller: null,
                    decoration: InputDecoration(
                        labelText: "Location",
                        hintText: "Location",
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
                            .whenComplete(()=>{
                              _createData()
                            });

                          //after adding new data, clear the form
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