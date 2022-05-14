import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.submitForm, required this.isLoading})
      : super(key: key);
  final void Function({
    required String username,
    File image,
    required String email,
    required String password,
    required bool isLogin,
  }) submitForm;
  final bool isLoading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _clearTextField() {
    _usernameController.clear();
    _userEmailController.clear();
    _passwordController.clear();
  }

  // ignore: unused_field
  String _userEmail = "";
  String _username = "";
  String _password = "";
  File? _userImageFile;
  void _trySubmit() {
    final isVaild = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isVaild && (_userImageFile != null || !_isLogin)) {
      _formKey.currentState!.save();

      widget.submitForm(
        email: _userEmail.trim(),
        password: _password,
        username: _username,
        isLogin: _isLogin,
        image: _userImageFile!,
      );
      _clearTextField();
    }
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  bool _isLogin = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin)
                  UserImagePicker(
                    imagePicker: _pickedImage,
                  ),
                if (!_isLogin)
                  TextFormField(
                    key: const Key('username'),
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                    ),
                    onSaved: (value) {
                      _username = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return "Username must be at lease 4 characters";
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  key: const Key('email'),
                  controller: _userEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email address",
                  ),
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return 'Please Enter a valid Email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  key: const Key('password'),
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return "Password must be at lease 7 charachters";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                widget.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.pink,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _trySubmit,
                        child: _isLogin
                            ? const Text("Login")
                            : const Text("Signup"),
                      ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: _isLogin
                      ? const Text("Create new Account")
                      : const Text("Already have an account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
