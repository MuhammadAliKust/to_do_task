import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:to_do_task/models/user_details.dart';
import 'package:to_do_task/scoped_model.dart/main.dart';
import 'package:to_do_task/screens/authentication/signUp.dart';
import 'package:to_do_task/screens/tasks/display.dart';
import 'package:to_do_task/widget_utils/loader.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isObscured = true;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'emailId': null,
    'password': null,
  };
  Widget _buildListView(BuildContext contxt) {
    return ListView(children: <Widget>[
      _buildImage(),
      Form(
        key: _formKey,
        child: Column(children: <Widget>[
          _buildEmailField(),
          _buildPasswordField(),
          SizedBox(
            height: 10,
          ),
          _buildFlatButton(contxt),
        ]),
      ),
      SizedBox(
        height: 10,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text('Don\'t have an account? '),
        InkWell(
            child: Text("Create an account."),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            }),
      ]),
      SizedBox(
        height: 10,
      ),
    ]);
  }

  Widget _buildImage() {
    return Image.asset(
      'images/toDo.png',
      height: 230,
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
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

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
      child: TextFormField(
        onSaved: (val) {
          _formData['password'] = val;
        },
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

  Widget _buildFlatButton(BuildContext contxt) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 75, vertical: 10),
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return model.isLoading
                ? CircularProgressIndicator()
                : FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35))),
                    color: Color(0xff6135bc),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AutoSizeText(
                            'Sign In',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      final Map<String, dynamic> successInfo =
                          await model.signUp(_formData['emailId'],
                              _formData['password'], true);

                      if (successInfo['success']) {
                        Navigator.push(
                            contxt,
                            MaterialPageRoute(
                                builder: (_context) => Display(model)));
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
                    },
                  );
          },
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext contxt) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return SafeArea(
          child: Scaffold(body: _buildListView(contxt)),
        );
      },
    );
  }
}

MyGlobals myGlobals = new MyGlobals();

class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}
