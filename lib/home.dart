import 'package:flutter/material.dart';
import 'package:flutter_biometric/auth.dart';
import 'package:flutter_biometric/blocs/theme.dart';
import 'package:flutter_biometric/themeoption.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _HomeState();
    }
}

class _HomeState extends State<Home> {

  File _image;
  bool _uploaded = false;
  StorageReference _reference = FirebaseStorage.instance.ref().child(
      'myimage.jpg');

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _image = image;
    });
  }

  Future uploadImage() async {
    StorageUploadTask uploadTask = _reference.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      _uploaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      theme: theme.getTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home'),

          actions: <Widget>[

            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(
                    builder: (c) => Auth()));
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(
                    context).push (MaterialPageRoute(
                    builder: (context) => ThemeOption()));
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.insert_drive_file),
                onPressed: () {
                  getImage(false);
                },
              ),
              SizedBox(height: 10.0,),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  getImage(true);
                },
              ),

              _image == null ? Container() : Image.file(
                  _image, height: 300.0, width: 300.0),


              _image == null ? Container() : RaisedButton(
                child: Text("Upload to Storage"),
                onPressed: () {
                  uploadImage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
