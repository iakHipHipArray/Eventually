import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;
  Future getImage() async{
    var image= await ImagePicker.pickImage(source: ImageSource.gallery);
    setState((){
      _image= image;
      print('Image Path $_image');
    });
  }
  
    Future uploadPic(BuildContext context) async{
      String fileName = basename(_image.path);
       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
       StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
       setState(() {
          print("Profile Picture uploaded");
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
       });
    }
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
       body:_buildBody(context)
    );  
  }


Widget _buildBody(BuildContext context){
  return StreamBuilder(
    stream: Firestore.instance.collection('users').document('rmpillar').snapshots(),
    builder: (context, snapshot) {
      final user= snapshot.data.data;
      final firstName = user['firstName'];
      final lastName =user['lastName'];
      final username = user['username'];
      if (!snapshot.hasData) return Text('LOADING');

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildProfileImage(context),
          _buildInfo(context, firstName, lastName, username),
         
        ],
      );
    

    },
    
  );
}



Widget _buildProfileImage(context) {
    return Column(     
      children: <Widget>[
               SizedBox(height:50.0),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      
                      radius: 100,
                      backgroundColor: Colors.blue,
                      child: ClipOval(
                        child: new SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child:(_image!=null)?Image.file(_image,fit:BoxFit.fill,):Image.network(
                            'http://www.racemph.com/wp-content/uploads/2016/09/profile-image-placeholder.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                      ),
                      onPressed: () {
                         getImage().whenComplete((){uploadPic(context);});
                      },
                    ),
                  ),
                ],
              )],
    );
  }


    Widget _buildInfo(context, firstName, lastName, username) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          
          children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('user ID',
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 18.0)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('$username',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Name',
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 18.0)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('$firstName $lastName',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('location',
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 18.0)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('This will be location',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
           ],)

           );
  }

}