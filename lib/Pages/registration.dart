import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRegistration extends StatefulWidget {
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  TextEditingController emailEditingContrller = TextEditingController();
  String username, firstName, lastName, email, password;
  
  getUserName(username){
    this.username=username;
  }

  getFirstName(firstName){
    this.firstName=firstName;
  }
  getLastName(lastName){
    this.lastName=lastName;
  }
  
  getEmail(email){
    this.email=email;
  }
  getPassword(password){
    this.password=password;
  }
  
  createData(){
  DocumentReference db= FireStore.instance.collection('users').document(username);
  Map<String,dynamic> newUser={
    'firstName' :firstName,
    'lastName':lastName,
    'username':username,
  };
  print(newUser);
  // db.setData(newUser).whenComplete(()=>{
  //   print('new user added')});
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
                    controller: null,
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
                    onChanged: (String username){
                      getUserName(username);
                    },
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
                    onChanged: (String firstName){
                      getFirstName(firstName);
                    },
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
                    onChanged: (String lastName){
                      getLastName(lastName);
                    },
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
                    controller: emailEditingContrller,
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
                    onChanged: (String email){
                      getEmail(email);
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    autofocus: false,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: emailEditingContrller,
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
                    onChanged: (String password){
                      getPassword(password);
                    },
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[                    
                    RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                         //function to reset the state
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white,
                        )),
                    ),
                    
                    RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          createData();
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