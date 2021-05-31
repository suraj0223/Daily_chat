import 'package:flutter/cupertino.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/loginbackground.jpg'),
            alignment: Alignment.center,
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            decoration: BoxDecoration(
                color: Colors.white12, borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            duration: Duration(milliseconds: 800),
            height: _islogin
                ? MediaQuery.of(context).size.height * 0.45
                : MediaQuery.of(context).size.height * 0.52,
            width: MediaQuery.of(context).size.width * 0.9,
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
                    cursorHeight: 25,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 17),
                      errorStyle: TextStyle(color: Colors.pink, fontSize: 13),
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_islogin)
                    TextFormField(
                      key: ValueKey('username'),
                      cursorHeight: 25,
                      validator: (value) {
                        if (value.isEmpty || value.trim().length < 4)
                          return 'Too short';
                        return null;
                      },
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'UserName',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 17),
                          errorStyle:
                              TextStyle(color: Colors.pink, fontSize: 13)),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    cursorHeight: 25,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7)
                        return 'Password must be 7 characters long';
                      return null;
                    },
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5), fontSize: 17),
                        errorStyle:
                            TextStyle(color: Colors.pink, fontSize: 13)),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  _islogin
                      ? Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text(
                              'Forgot password',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        )
                      : Padding(padding: EdgeInsets.all(3)),
                  ElevatedButton(
                    child: Text(_islogin ? 'Login' : 'SignUp'),
                    onPressed: _trySubmit,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF25d366),
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
                      TextButton(
                        child: Text(
                          _islogin ? 'Register Now' : 'SignIn now',
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
