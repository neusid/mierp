import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterRepository extends GetxController {

  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStore = FirebaseFirestore.instance;

  Future<UserCredential> CreateNewAccount(email,password,f_name,l_name,role) async {
    try {
      final data = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return data;
    } catch(e) {
      rethrow;
    }
  }

  Future<void> AddNewFstoreData(uid,email,f_name,l_name,role) async {
    try {
      await firebaseStore.collection("users").doc(uid).set({
        'email':email,
        'first_name':f_name,
        'last_name':l_name,
        'role':role,
        'allow_google_login':false
      });
    } catch(e) {
      rethrow;
    }
  }
}