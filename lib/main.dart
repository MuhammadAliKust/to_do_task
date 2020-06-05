import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:to_do_task/scoped_model.dart/main.dart';
import 'package:to_do_task/screens/authentication/signIn.dart';
import 'package:to_do_task/screens/authentication/signUp.dart';
import 'package:to_do_task/screens/tasks/display.dart';

import 'package:to_do_task/screens/tasks/edit_task.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();

  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? SignIn() : Display(_model),
          
        },
      ),
      
    );
  }
}
