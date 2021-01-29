import 'package:flutter/material.dart';
import 'package:future_button/future_button.dart';
import 'package:progress_indicators/progress_indicators.dart';

class AuthForm extends StatefulWidget {
  final Future<bool> Function(
    String email,
    String username,
    String password,
    bool isLogin,
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
  bool _isSaving = false;

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    setState(() {
      _isSaving = true;
    });
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      try {
        var success = await widget.submitData(
          _userEmail.trim(),
          _userName.trim(),
          _userPassword.trim(),
          _isLogin,
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
                  TextFormField(
                    key: ValueKey('email'),
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
