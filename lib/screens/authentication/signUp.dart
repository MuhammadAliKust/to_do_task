import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:to_do_task/scoped_model.dart/main.dart';
import 'package:to_do_task/screens/authentication/signIn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isObscured = true;
  TextEditingController _pwdController = TextEditingController();
  final Map<String, dynamic> _formData = {
    'emailId': null,
    'password': null,
    'username': null,
  };
  final _formKey = GlobalKey<FormState>();
  Widget _listViewBuilder() {
    return ListView(children: <Widget>[
      _imageBuilder(),
      Form(
          key: _formKey,
          child: Column(children: <Widget>[
            _userNameFieldBuilder(),
            _emailFieldBuilder(),
            _passwordFieldBuilder(),
            _confirmPasswordFieldBuilder(),
            SizedBox(
              height: 10,
            ),
            _flatButtonBuilder(),
          ])),
      SizedBox(
        height: 5,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text('Alreadt have an account? '),
        InkWell(
          child: Text("SingIn Now"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          },
        )
      ]),
      SizedBox(
        height: 10,
      ),
    ]);
  }

  Widget _imageBuilder() {
    return Image.asset(
      'images/toDo.png',
      height: 240,
    );
  }

  Widget _userNameFieldBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 5),
      child: TextFormField(
        onSaved: (val) {
          _formData['username'] = val;
        },
        validator: (val) =>
            val.isEmpty ? "Username field cannot be empty." : null,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.supervised_user_circle,
              size: 18,
            ),
            hintText: 'Username',
            hintStyle: TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _emailFieldBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 5),
      child: TextFormField(
        onSaved: (val) {
          _formData['emailId'] = val;
        },
        validator: (val) => val.isEmpty ? "Email field cannot be empty." : null,
        decoration: InputDecoration(
            prefixIcon: Icon(
              MdiIcons.email,
              size: 18,
            ),
            hintText: 'Email ID',
            hintStyle: TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _passwordFieldBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 5),
      child: TextFormField(
        onSaved: (val) {
          _formData['password'] = val;
        },
        controller: _pwdController,
        validator: (val) =>
            val.isEmpty ? "Password field cannot be empty." : null,
        obscureText: isObscured,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              size: 18,
            ),
            suffixIcon: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
                child: isObscured
                    ? Icon(
                        Icons.remove_red_eye,
                        size: 18,
                      )
                    : Icon(
                        MdiIcons.eyeOff,
                        size: 18,
                      )),
            hintText: 'Password',
            hintStyle: TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _confirmPasswordFieldBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 5),
      child: TextFormField(
        validator: (val) =>
            _pwdController.text != val ? "Password does not match." : null,
        obscureText: isObscured,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              size: 18,
            ),
            hintText: 'Confirm Password',
            hintStyle: TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _flatButtonBuilder() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 55, vertical: 10),
        child: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
          return model.isLoading
              ? CircularProgressIndicator()
              : FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                  color: Color(0xff6135bc),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                    child: AutoSizeText(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, letterSpacing: 1),
                      maxLines: 1,
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    _formKey.currentState.save();
                    model.addUserDetails(
                        _formData['username'], _formData['emailId']);
                    final Map<String, dynamic> successInfo = await model.signUp(
                        _formData['emailId'], _formData['password'], false);
                    if (successInfo['success']) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('An Error Occurred!'),
                              content: Text(successInfo['message']),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
                  });
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.white, body: _listViewBuilder()),
    );
  }
}
