import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:to_do_task/constants/constants.dart';
import 'package:to_do_task/main.dart';
import 'package:to_do_task/scoped_model.dart/main.dart';
import 'package:to_do_task/screens/authentication/signIn.dart';
import 'package:to_do_task/screens/tasks/edit_task.dart';
import 'package:to_do_task/widget_utils/custom_bottom_navigationbar.dart';
import 'package:to_do_task/widget_utils/loader.dart';

class Display extends StatefulWidget {
  final MainModel model;
  Display(this.model);
  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  bool isTaskCompleted = false;
  bool isPressed = false;
  String _value;
  Widget _buildColumn() {
    return Column(children: <Widget>[
      Container(
        color: Color(0xff6135bc),
        height: 80,
        child: Padding(
          padding: EdgeInsets.only(left: 18.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildUserName(),
                ScopedModelDescendant(
                  builder:
                      (BuildContext context, Widget child, MainModel model) {
                    return IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          model.logout();
                          Navigator.of(context).pushReplacementNamed('/');
                        });
                  },
                )

                // _buildDropDownMenu(),
              ]),
        ),
      ),
      Expanded(
          child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(children: <Widget>[
              SizedBox(
                height: 20,
              ),
              _buildHeader(),
              Container(height: 300, child: _buildCard(1)),
            ]),
          ),
        ),
      )),
    ]);
  }

  Widget _buildDropDown() {
    return PopupMenuButton<String>(
      onSelected: choiceAction,
      itemBuilder: (BuildContext context) {
        return Constants.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Settings) {
      print('Settings');
    } else if (choice == Constants.Subscribe) {
      print('Subscribe');
    } else if (choice == Constants.SignOut) {
      ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return ListTile(
            leading: Text("Logout"),
            onTap: () {
              model.logout();
            },
          );
        },
      );
    }
  }

  Widget _buildHeader() {
    return Text("My Tasks");
  }

  Widget _buildCard(int index) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget myListView = ListView.builder(
          itemCount: model.allTasks.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(model.allTasks[index].taskId),
                child: Card(child: _buildListTile(model, index)),
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart) {
                    model.selectTask(model.allTasks[index].taskId);
                    model.deleteTask();
                  }
                });
          });
      if (model.allTasks.length > 0) {
        return myListView;
      } else {
        return Center(child: Text("No active tasks found."));
      }
    });
  }

  Widget _buildListTile(MainModel model, int index) {
    return ListTile(
      leading: _buildLeading(model, index),
      title: _buildTitle(model, index),
      subtitle: _buildSubTitle(model, index),
      trailing: _buildTrailing(context, index, model),
    );
  }

  Widget _buildLeading(MainModel model, int index) {
    return Column(
      children: <Widget>[
        Text(model.allTasks[index].taskTime),
        SizedBox(
          height: 10,
        ),
        InkWell(
            child: Icon(
              model.allTasks[index].isCompleted
                  ? MdiIcons.checkBoxOutline
                  : MdiIcons.checkboxBlankOutline,
              size: 16,
            ),
            onTap: () {
              model.selectTask(model.allTasks[index].taskId);
              model.toggleTasksCompletedStatus();
            })
      ],
    );
  }

  Widget _buildTitle(MainModel model, int index) {
    return SizedBox(child: Text(model.allTasks[index].taskName));
  }

  Widget _buildSubTitle(MainModel model, int index) {
    return Text(model.allTasks[index].taskDescription);
  }

  // Widget _buildEditButton(BuildContext context, int index, MainModel model) {
  //   return IconButton(
  //     icon: Icon(Icons.edit),
  //     onPressed: () {
  //       model.selectTask(model.allTasks[index].taskId);
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (BuildContext context) {
  //             return EditTask(
  //               isRequiredUpdate: true,
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildTrailing(BuildContext context, int index, MainModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            return !model.allTasks[index].isCompleted
                ? InkWell(
                    child: Icon(Icons.edit, size: 16),
                    onTap: () {
                      model.selectedTaskIndex;
                      model.selectTask(model.allTasks[index].taskId);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditTask(
                                    isRequiredUpdate: true,
                                  )));
                    },
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        'Completed',
                        style: TextStyle(fontSize: 11),
                      ),
                    ));
          },
        ),
      ],
    );
  }

  Widget _buildUserName() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Text(
          model.allUsers[0].name == null
              ? "Welcome User"
              : "Welcome  ${model.allUsers[0].name}".toString().toUpperCase(),
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1),
        );
      },
    );
  }

  Widget _buildHorizontalListView() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Container(
              width: 60,
              child: Card(
                color: isPressed ? Colors.white : Colors.transparent,
                child: Column(
                  children: <Widget>[
                    Text('20'),
                    Text('May'),
                    Text('3 Task'),
                  ],
                ),
              ),
            ),
            onTap: () {
              _buildCard(3);
              setState(() {
                isPressed = !isPressed;
              });
            },
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState

    widget.model
        .fetchUserID()
        .then((value) => widget.model.fetchTasks(onlyForUser: false));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return SafeArea(
                child: Scaffold(
                    backgroundColor: Color(0xff6135bc),
                    body: model.isLoading
            ? Container(
                child: Loading(),
                width: MediaQuery.of(context).size.width,
               height: MediaQuery.of(context).size.height-10,
                color: Colors.white,
              )
            : _buildColumn(),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    floatingActionButton: showFab
                        ? FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditTask(isRequiredUpdate: false,)));
                            },
                            child: Icon(Icons.add),
                            backgroundColor: Color(0xff6135bc))
                        : null,
                    bottomNavigationBar: CustonBottomNavigationBar(model)),
              );
      },
    );
  }
}
