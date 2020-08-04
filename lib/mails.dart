import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flumail/addmail.dart';
import 'package:flumail/navigation.dart';
import 'package:flumail/utils/variables.dart';
import 'package:flumail/viewmail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as tago;

class MailsPage extends StatefulWidget {
  @override
  _MailsPageState createState() => _MailsPageState();
}

class _MailsPageState extends State<MailsPage> {
  String profilepic = '';
  String currentemail;
  Stream mystream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuserdata();
    getstream();
  }

  getcurrentuserdata() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    print(firebaseuser.email);
    DocumentSnapshot documentSnapshot =
        await users.document(firebaseuser.email).get();
    setState(() {
      profilepic = documentSnapshot['profilepic'];
      currentemail = firebaseuser.email;
    });
  }

  getstream() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    print(firebaseuser.email);
    setState(() {
      mystream =
          users.document(firebaseuser.email).collection('inbox').snapshots();
    });
  }

  searchmail(s) async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    setState(() {
      mystream = users
          .document(firebaseuser.email)
          .collection('inbox')
          .where('subject', isGreaterThanOrEqualTo: s)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Material(
          elevation: 8,
          child: TextFormField(
            onFieldSubmitted: (s) => searchmail(s),
            decoration: InputDecoration(
                hintText: 'Search Mail',
                border: InputBorder.none,
                icon: InkWell(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Icon(Icons.dehaze),
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    print(username);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(profilepic),
                    ),
                  ),
                )),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddMail())),
        child: Icon(
          Icons.add,
          size: 45,
          color: Colors.red,
        ),
      ),
      body: StreamBuilder(
          stream: mystream,
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (dataSnapshot.data.documents.length == 0)
              return Center(
                child: Text(
                  "Inbox is empty",
                  style: mystyle(35),
                ),
              );

            if (dataSnapshot.data.documents.length > 0)
              return ListView.builder(
                itemCount: dataSnapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot document =
                      dataSnapshot.data.documents[index];

                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewMail(
                            document['id'],
                            document['sender'],
                            document['time'],
                            document['image'],
                            document['mail'],
                            document['subject'],
                            document['profilepic'],
                            document['username']),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    NetworkImage(document['profilepic']),
                              ),
                              SizedBox(width: 15.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    document['username'],
                                    style: mystyle(
                                        22,
                                        document['hasred'] == false
                                            ? Colors.black
                                            : Colors.black,
                                        document['hasred'] == false
                                            ? FontWeight.w700
                                            : FontWeight.w400),
                                  ),
                                  Text(
                                    document['subject'],
                                    style: mystyle(
                                        18,
                                        document['hasred'] == false
                                            ? Colors.black
                                            : Colors.grey,
                                        FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 5.0),
                          Column(
                            children: <Widget>[
                              Text(
                                '12:30',
                                style: mystyle(
                                    18,
                                    document['hasred'] == false
                                        ? Colors.black
                                        : Colors.grey,
                                    FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              document['stared'] == false
                                  ? InkWell(
                                      onTap: () {
                                        users
                                            .document(currentemail)
                                            .collection('inbox')
                                            .document(document['id'])
                                            .updateData({
                                          'stared': true,
                                        });
                                      },
                                      child: Icon(
                                        Icons.star_border,
                                        size: 32,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        users
                                            .document(currentemail)
                                            .collection('inbox')
                                            .document(document['id'])
                                            .updateData({
                                          'stared': false,
                                        });
                                      },
                                      child: Icon(Icons.star,
                                          size: 32, color: Colors.yellow),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
          }),
    );
  }
}
