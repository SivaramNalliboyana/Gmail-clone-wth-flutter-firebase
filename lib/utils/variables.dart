import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

var exampleimage =
    'https://upload.wikimedia.org/wikipedia/commons/9/9a/Mahesh_Babu_in_Spyder_%28cropped%29.jpg';

TextStyle mystyle(double size, [Color color, FontWeight fw = FontWeight.w700]) {
  return GoogleFonts.montserrat(fontSize: size, fontWeight: fw, color: color);
}

CollectionReference users = Firestore.instance.collection('users');

StorageReference profile = FirebaseStorage.instance.ref().child('profilepics');
