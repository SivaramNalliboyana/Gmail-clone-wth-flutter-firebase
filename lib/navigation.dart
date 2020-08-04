import 'package:firebase_auth/firebase_auth.dart';
import 'package:flumail/mails.dart';
import 'package:flumail/signup.dart';
import 'package:flumail/utils/variables.dart';
import 'package:flutter/material.dart';

String username = '';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool isSigned = false;

  void initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((useraccount) {
      if (useraccount != null) {
        setState(() {
          isSigned = true;
        });
      } else {
        setState(() {
          isSigned = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSigned == false ? Login() : MailsPage(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
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
                  "Login",
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
                      hintText: "Mail",
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
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.lightBlue[200],
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        "Create Account",
                        style: mystyle(20),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.lightBlue[200],
                      onPressed: () {
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: usernamecontroller.text + '@flumail.com',
                            password: passwordcontroller.text);
                        setState(() {
                          username = usernamecontroller.text;
                        });
                      },
                      child: Text(
                        "Login",
                        style: mystyle(20),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
    ;
  }
}
