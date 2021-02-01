import 'dart:io';

import '../../pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:future_button/future_button.dart';

class AuthForm extends StatefulWidget {
  final Future<bool> Function(
    String email,
    String username,
    String password,
    bool isLogin,
    File userPic,
    BuildContext ctx,
  ) submitData;
  AuthForm(this.submitData);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _showPass = false;
  bool _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File _pickeImage;
  bool _isSaving = false;

  File pickedImage(File img) {
    _pickeImage = img;
  }

  Future<void> _trySubmit() async {
    FocusScope.of(context).unfocus();
    try {
      if (_pickeImage == null && !_isLogin) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Plase take a picture'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        throw Exception();
        // return showDialog<void>(
        //   context: context,
        //   barrierDismissible: false, // user must tap button!
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text('Missing Profile Image'),
        //       content: SingleChildScrollView(
        //         child: ListBody(
        //           children: <Widget>[
        //             Text('Plase take a pic'),
        //           ],
        //         ),
        //       ),
        //       actions: <Widget>[
        //         TextButton(
        //           child: Text('OK'),
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //       ],
        //     );
        //   },
        // );
      }
    } catch (error) {
      throw error;
    }
    final isValid = _formKey.currentState.validate();
    setState(() {
      _isSaving = true;
    });
    if (isValid) {
      _formKey.currentState.save();
      try {
        var success = await widget.submitData(
          _userEmail.trim(),
          _userName.trim(),
          _userPassword.trim(),
          _isLogin,
          _pickeImage,
          context,
        );
      } catch (err) {
        throw err;
      }
    }
    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (typedText) {
                      if (typedText.isEmpty || !typedText.contains('@')) {
                        return 'Please, enter a valid e-mail address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                    ),
                    onSaved: (value) {
                      _userEmail = value.toLowerCase();
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (typedText) {
                        if (typedText.isEmpty) {
                          return 'Please, enter a username.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userName = value.toLowerCase();
                      },
                    ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFormField(
                        key: ValueKey('password'),
                        validator: (typedText) {
                          if (typedText.isEmpty || typedText.length < 7) {
                            return 'Please, enter a valid password. Needs to be 7 characters long!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: !_showPass,
                        onSaved: (value) {
                          _userPassword = value;
                        },
                      ),
                      IconButton(
                          icon: Icon(_showPass
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _showPass = !_showPass;
                            });
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureRaisedButton(
                    showResult: true,
                    onPressed: () async => await _trySubmit(),
                    animateTransitions: true,
                    child: Text(_isLogin ? 'Login' : 'Register Free Now'),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                        _isLogin ? 'Create New Account' : 'Sign In Instead'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
