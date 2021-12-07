// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../pickers/user_image_picker.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String password,
      File image, bool isLogin, BuildContext ctx) submitFn;
  final bool isLoading;
  AuthForm(this.submitFn, this.isLoading);

  @override
  _State createState() => _State();
}

class _State extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;

  String _userEmail = '';
  String _userName = '';
  String _userPass = '';

  File? _userImageFile;

  void _pickedImage(File file) {
    _userImageFile = file;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
          _userEmail, _userName, _userPass, _userImageFile!, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                    validator: (value) {
                      if (value.toString().isEmpty ||
                          !value.toString().contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    key: ValueKey('email'),
                    onSaved: (value) {
                      _userEmail = value.toString();
                    }),
                if (!_isLogin)
                  TextFormField(
                    validator: (value) {
                      if (value.toString().isEmpty ||
                          value.toString().length < 4) {
                        return 'Username must be at least 4 character long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                    key: ValueKey('username'),
                    onSaved: (value) {
                      _userName = value.toString();
                    },
                  ),
                TextFormField(
                  validator: (value) {
                    if (value.toString().isEmpty ||
                        value.toString().length < 7) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  key: ValueKey('password'),
                  onSaved: (value) {
                    _userPass = value.toString();
                  },
                  obscureText: true,
                ),
                SizedBox(
                  height: 12,
                ),
                widget.isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text(_isLogin ? 'Login' : 'Signup'),
                        onPressed: _trySubmit,
                      ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin
                      ? 'Create new account'
                      : 'I already have an account'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
