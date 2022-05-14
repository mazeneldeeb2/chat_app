import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _submitAuthForm({
    String? username,
    File? image,
    required String? email,
    required String? password,
    required bool isLogin,
  }) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final UserCredential authResult;
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user!.uid + '.jpg');
        var url;
        await ref.putFile(image!).whenComplete(() async {
          url = await ref.getDownloadURL();
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } catch (error) {
      String message = 'An Error Occured, please check your credentials.';
      setState(() {
        _isLoading = false;
      });
      int start = error.toString().indexOf("The");
      message = error.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitForm: _submitAuthForm,
        isLoading: _isLoading,
      ),
    );
  }
}
