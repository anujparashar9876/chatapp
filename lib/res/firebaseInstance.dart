import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Instances{
  static FirebaseAuth auth=FirebaseAuth.instance;
  static FirebaseFirestore firestore=FirebaseFirestore.instance;
  static FirebaseStorage store=FirebaseStorage.instance;
}