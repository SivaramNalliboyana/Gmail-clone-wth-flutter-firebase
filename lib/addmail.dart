import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flumail/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddMail extends StatefulWidget {
  @override
  _AddMailState createState() => _AddMailState();
}

class _AddMailState extends State<AddMail> {
  var scaffoldkey = GlobalKey<ScaffoldState>();

  File imagepath;
  TextEditingController reciever = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController mail = TextEditingController();
  pickimage(ImageSource imageSource) async {
    Navigator.pop(context);
    final imagefile = await ImagePicker()
        .getImage(source: imageSource, maxHeight: 680, maxWidth: 970);
    setState(() {
      imagepath = File(imagefile.path);
    });
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

  var imageid = Uuid().v4();

  uploadimage() async {
    StorageUploadTask storageUploadTask =
        profile.child(imageid).putFile(imagepath);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  sendmail() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot document = await users.document(firebaseuser.email).get();
    try {
      String downloadurl = imagepath != null ? await uploadimage() : 'null';
      var id = users
          .document(reciever.text)
          .collection('inbox')
          .document()
          .documentID;
      users.document(reciever.text).collection('inbox').document(id).setData({
        'sender': firebaseuser.email,
        'reciever': reciever.text,
        'subject': subject.text,
        'mail': mail.text,
        'hasred': false,
        'stared': false,
        'id': id,
        'time': DateTime.now(),
        'image': downloadurl,
        'profilepic': document['profilepic'],
        'username': document['username']
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
      SnackBar snackBar =
          SnackBar(content: Text("Mail could not be sent, try again"));
      scaffoldkey.currentState.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => sendmail(),
        child: Icon(Icons.send),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          InkWell(
            onTap: () => optionsdialog(context),
            child: Icon(Icons.attach_file, color: Colors.black),
          ),
        ],
        title: Text(
          'Compose email',
          style: mystyle(20, Colors.black),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .1,
              child: TextFormField(
                controller: reciever,
                style: mystyle(20),
                decoration: InputDecoration(
                  labelText: "To",
                  labelStyle: mystyle(20),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .1,
              child: TextFormField(
                controller: subject,
                style: mystyle(20, Colors.black, FontWeight.w500),
                decoration: InputDecoration(
                    labelText: "Subject", labelStyle: mystyle(20)),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: mail,
                  maxLines: null,
                  style: mystyle(20, Colors.black, FontWeight.w600),
                  decoration: InputDecoration(
                      labelText: "Mail",
                      labelStyle: mystyle(20),
                      border: InputBorder.none),
                ),
              ),
            ),
            imagepath == null
                ? Container()
                : MediaQuery.of(context).viewInsets.bottom > 0.0
                    ? Container()
                    : Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "Your attachment",
                              style: mystyle(20),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              child: Image(
                                image: FileImage(imagepath),
                              ),
                            ),
                          ],
                        ),
                      )
          ],
        ),
      ),
    );
  }
}
