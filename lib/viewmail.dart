import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flumail/addmail.dart';
import 'package:flumail/utils/variables.dart';
import 'package:flutter/material.dart';

class ViewMail extends StatefulWidget {
  final String id;
  final String sender;
  final Timestamp time;
  final String picture;
  final String mail;
  final String subject;
  final String profilepic;
  final String username;
  ViewMail(this.id, this.sender, this.time, this.picture, this.mail,
      this.subject, this.profilepic, this.username);
  @override
  _ViewMailState createState() => _ViewMailState();
}

class _ViewMailState extends State<ViewMail> {
  @override
  void initState() {
    super.initState();
    markasread();
  }

  markasread() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    users
        .document(firebaseuser.email)
        .collection('inbox')
        .document(widget.id)
        .updateData({'hasred': true});
  }

  showimage(econtext) {
    return showDialog(
        context: econtext,
        builder: (context) {
          return Dialog(
            child: Container(
              width: 500,
              height: 500,
              child: Image(
                image: NetworkImage(widget.picture),
                fit: BoxFit.cover,
              ),
            ),
          );
        });
  }

  deletedocument() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    users
        .document(firebaseuser.email)
        .collection('inbox')
        .document(widget.id)
        .delete();
    Navigator.pop(context);
  }

  deletemail(econtext) {
    return showDialog(
        context: econtext,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Are you sure you want to delete this mail",
              style: mystyle(20),
            ),
            actions: <Widget>[
              FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                    deletedocument();
                  },
                  child: Text(
                    "Yes",
                    style: mystyle(20),
                  )),
              FlatButton(
                  color: Colors.lightBlue,
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "No",
                    style: mystyle(20, Colors.white),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddMail())),
            child: Icon(
              Icons.reply,
              size: 32,
              color: Colors.black,
            ),
          ),
          InkWell(
            onTap: () => deletemail(context),
            child: Icon(
              Icons.delete,
              size: 32,
              color: Colors.red,
            ),
          )
        ],
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 32,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.subject,
              style: mystyle(35),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.profilepic),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.username,
                        style: mystyle(20),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddMail())),
                        child: Icon(
                          Icons.reply,
                          size: 32,
                        ),
                      ),
                      Icon(Icons.dehaze, size: 32)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.mail,
                  style: mystyle(20, Colors.black, FontWeight.w400)),
            ),
            SizedBox(height: 40),
            Text(
              "Attachments",
              style: mystyle(20, Colors.black, FontWeight.w500),
            ),
            SizedBox(
              height: 20.0,
            ),
            widget.picture == 'null'
                ? Container()
                : InkWell(
                    onTap: () => showimage(context),
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Image(
                          image: NetworkImage(widget.picture),
                          fit: BoxFit.cover),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
