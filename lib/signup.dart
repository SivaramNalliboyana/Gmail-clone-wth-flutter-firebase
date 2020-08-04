import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flumail/models/usermodel.dart';
import 'package:flumail/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  File imagepath;

  pickimage(ImageSource imageSource) async {
    Navigator.pop(context);
    final imagefile = await ImagePicker()
        .getImage(source: imageSource, maxHeight: 680, maxWidth: 970);
    setState(() {
      imagepath = File(imagefile.path);
    });
  }

  Future<String> uploadimage() async {
    StorageUploadTask storageUploadTask =
        profile.child(usernamecontroller.text).putFile(imagepath);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  registeruser() async {
    try {
      String downloadedpic = imagepath == null
          ? 'https://www.shareicon.net/data/2016/07/26/801997_user_512x512.png'
          : await uploadimage();
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: usernamecontroller.text + '@flumail.com',
              password: passwordcontroller.text)
          .then((signeduser) {
        User().storeuser(
            signeduser.user,
            usernamecontroller.text + '@flumail.com',
            passwordcontroller.text,
            usernamecontroller.text,
            downloadedpic);
        Navigator.pop(context);
      });
    } catch (e) {
      print(e);
    }
  }

  optionsdialog(econtext) {
    return showDialog(
        context: econtext,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => pickimage(ImageSource.gallery),
                child: Text(
                  "Choose from gallery",
                  style: mystyle(20, Colors.lightBlue),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickimage(ImageSource.camera),
                child: Text(
                  "Choose from camera",
                  style: mystyle(20, Colors.lightBlue),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: mystyle(20, Colors.lightBlue),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2 + 300,
          child: Card(
            elevation: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Floogle",
                  style: mystyle(25, Colors.purple),
                ),
                SizedBox(height: 5.0),
                Text(
                  "Create a account",
                  style: mystyle(18, Colors.black),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Continue to flumail",
                  style: mystyle(18, Colors.black),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextField(
                    controller: usernamecontroller,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextField(
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Repeat password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () => optionsdialog(context),
                      child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.lightBlue),
                          child: imagepath == null
                              ? Center(
                                  child: Icon(Icons.add),
                                )
                              : Image(image: FileImage(imagepath))),
                    ),
                    Text(
                      "Choose a profile image",
                      style: mystyle(20),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  color: Colors.lightBlue[200],
                  onPressed: () => registeruser(),
                  child: Text(
                    "Register",
                    style: mystyle(20),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
