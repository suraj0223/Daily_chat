import 'package:flutter/material.dart';
class AuthForm extends StatefulWidget {
  AuthForm(this.submitFrm);
  final void Function(
    String email,
    String password,
    String username,
    bool islogin,
    BuildContext context,
  ) submitFrm;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _islogin = true;

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _trySubmit() {
    final isvalid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();
    if (isvalid) {
      _formKey.currentState.save();

      }
      widget.submitFrm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _islogin,
        context,
      );
    
  }

  @override
  Widget build(BuildContext context) {
    print('running..');
    return Scaffold(
      backgroundColor: Color(0xFF075f54),
      body: Center(
        child: AnimatedContainer(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          duration: Duration(milliseconds: 800),
          height: _islogin
              ? MediaQuery.of(context).size.height * 0.45
              : MediaQuery.of(context).size.height * 0.52,
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)
                          ? null
                          : "Enter correct email";
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 17),
                        errorStyle:
                            TextStyle(color: Colors.pink, fontSize: 13)),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_islogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4)
                          return 'Too short';
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'UserName',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 17),
                          errorStyle:
                              TextStyle(color: Colors.pink, fontSize: 13)),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7)
                        return 'Password must be 7 character long';
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 17),
                        errorStyle:
                            TextStyle(color: Colors.pink, fontSize: 13)),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  _islogin
                      ? Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            child: Text(
                              'Forgot password',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        )
                      : SizedBox(
                          height: 20,
                        ),
                  Container(
                    padding: EdgeInsets.only(top: 7, left: 7, right: 7),
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      child: Text(_islogin ? 'Login' : 'SignUp'),
                      onPressed: _trySubmit,
                      color: Color(0xFF25d366),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _islogin
                          ? Text(
                              'Dont\'t have an account?',
                              style: TextStyle(color: Colors.white),
                            )
                          : Text('Already have an account?',
                              style: TextStyle(color: Colors.white)),
                      FlatButton(
                        child: Text(
                          _islogin ? 'Register Now' : 'SignIn Now',
                          style: TextStyle(color: Colors.pinkAccent),
                        ),
                        onPressed: () {
                          setState(() {
                            _islogin = !_islogin;
                          });
                        },
                      ),
                    ],
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
