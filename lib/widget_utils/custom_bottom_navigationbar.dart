import 'package:flutter/material.dart';
import 'package:to_do_task/scoped_model.dart/main.dart';
import 'package:to_do_task/screens/contact.dart';
import 'package:to_do_task/screens/tasks/display.dart';
import 'package:to_do_task/screens/tasks/edit_task.dart';

class CustonBottomNavigationBar extends StatefulWidget {
  final MainModel model;
  CustonBottomNavigationBar(this.model);
  @override
  _CustonBottomNavigationBarState createState() =>
      _CustonBottomNavigationBarState();
}

class _CustonBottomNavigationBarState extends State<CustonBottomNavigationBar> {
  int _currentIndex = 0;
  bool isPressed = true;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        elevation: 10,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            isPressed = false;
          });
          if (_currentIndex == 0) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Display(widget.model)),
                (Route<dynamic> route) => false);
          } else if (_currentIndex == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Contact(widget.model)));
          }
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.home,
                color: Color(0xff6135bc),
              ),
              title: Text('Home')),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.call,
                color: Color(0xff6135bc),
              ),
              title: Text('Contacts'))
        ]);
  }
}
