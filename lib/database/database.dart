import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Database {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(data, context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    Map<String, Object> newData = Map<String, Object>.from(data);
    newData.remove("password");
    await users
        .doc(userId)
        .set(newData)
        .then((value) => print("User Added"))
        .catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Sign up failed'),
              content: Text(error.toString()),
            );
          });
    });
  }
}
