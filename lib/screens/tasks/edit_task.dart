import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:to_do_task/models/tasks.dart';
import 'package:to_do_task/scoped_model.dart/connected_task.dart';
import 'package:to_do_task/scoped_model.dart/main.dart';
import 'package:to_do_task/widget_utils/custom_bottom_navigationbar.dart';
import 'display.dart';

class EditTask extends StatefulWidget {
  final bool isRequiredUpdate;

  EditTask({this.isRequiredUpdate = false});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  bool isSwitched = false;
  DateTime pickedDate;
  TimeOfDay time;
  final _formKey = GlobalKey<FormState>();
  bool isDatePicked = false;
  bool isTimePicked = false;
  final Map<String, dynamic> _formData = {
    'taskName': null,
    'taskDescription': null
  };
  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    widget.isRequiredUpdate;
  }

  Widget _buildColumn(Tasks tasks) {
    print(widget.isRequiredUpdate);
    return Column(children: <Widget>[
      Container(color: Color(0xff6135bc), height: 100),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 45.0),
            child: Column(children: <Widget>[
              SizedBox(
                height: 20,
              ),
              _buildHeader(),
              _buildSizedBox(),
              Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  _buildTaskField(tasks),
                  _buildSizedBox(),
                  _buildTaskDescriptionField(tasks),
                  _buildSizedBox(),
                  _buildDateField(tasks),
                  _buildDivider(),
                  _buildSizedBox(),
                  _buildTimeField(tasks),
                  _buildDivider(),
                  _buildSizedBox(),
                  // _buildNotifyMeRow(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildFlatButton(),
                ]),
              ),
            ]),
          ),
        ),
      )),
    ]);
  }

  Widget _buildHeader() {
    return AutoSizeText(
      'Create a new task',
      style: TextStyle(
        fontSize: 21,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600,
      ),
      maxFontSize: 18,
      maxLines: 2,
    );
  }

  Widget _buildTaskField(Tasks task) {
    return TextFormField(
      initialValue: !widget.isRequiredUpdate ? '' : task.taskName,
      onSaved: (val) {
        _formData['taskName'] = val;
      },
      validator: (val) => val.isEmpty ? 'Task Name cannot be empty.' : null,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.list,
            size: 18,
          ),
          hintText: 'Task Name',
          hintStyle: TextStyle(fontSize: 14)),
    );
  }

  Widget _buildTaskDescriptionField(Tasks task) {
    return TextFormField(
      initialValue: !widget.isRequiredUpdate ? '' : task.taskDescription,
      onSaved: (val) {
        _formData['taskDescription'] = val;
      },
      decoration: InputDecoration(
          prefixIcon: Icon(
            MdiIcons.paperclip,
            size: 18,
          ),
          hintText: 'Task Description (Optional)',
          hintStyle: TextStyle(fontSize: 14)),
    );
  }

  Widget _buildDateField(Tasks task) {
    return ListTile(
      leading: Transform.translate(
          offset: Offset(-2, 0),
          child: Icon(
            Icons.date_range,
            size: 19,
          )),
      title: Transform.translate(
        offset: Offset(-24, 0),
        child: Text(
          getUpdatedDate(task),

          style: TextStyle(color: Color(0xff7d7d7d)),
          // widget.isRequiredUpdate
          //     ? task.taskDate
          //     : "${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}",
          // style: TextStyle(color: Color(0xff7d7d7d)),
        ),
      ),
      onTap: _pickDate,
    );
  }

  String getUpdatedDate(Tasks task) {
    if (widget.isRequiredUpdate) {
      if (isDatePicked == false) {
        return task.taskDate;
      } else {
        print("Date Called");
        return "${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}";
      }
    }
    return "${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}";
  }

  Widget _buildTimeField(Tasks task) {
    return ListTile(
      leading: Transform.translate(
          offset: Offset(-2, 0),
          child: Icon(
            Icons.timer,
            size: 19,
          )),
      title: Transform.translate(
        offset: Offset(-24, 0),
        child: Text(
          getUpdatedTime(task),
          style: TextStyle(color: Color(0xff7d7d7d)),
        ),
      ),
      onTap: _pickTime,
    );
  }

  String getUpdatedTime(Tasks task) {
    if (widget.isRequiredUpdate) {
      if (isTimePicked == false) {
        return task.taskTime;
      } else {
        return "${time.format(context)}";
      }
    }
    return "${time.format(context)}";
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1.4,
    );
  }

  Widget _buildNotifyMeRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Notify Me',
              style: TextStyle(color: Color(0xff7d7d7d)),
            ),
            CupertinoSwitch(
              value: isSwitched,
              onChanged: (val) {
                isSwitched = val;
              },
              activeColor: Color(0xff5e33b5),
            )
          ]),
    );
  }

  Widget _buildFlatButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? CircularProgressIndicator()
            : FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                color: Color(0xff6135bc),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      AutoSizeText(
                        'Add Task',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 1),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  _formKey.currentState.validate();
                  _formKey.currentState.save();
                  widget.isRequiredUpdate
                      ? model
                          .updateTask(
                            _formData['taskName'],
                            _formData['taskDescription'],
                            pickedDate.toIso8601String().substring(0, 10),
                            time
                                .toString()
                                .replaceAll('TimeOfDay(', '')
                                .replaceAll(')', ''),
                          )
                          .then((_) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Display(model))))
                      : model
                          .addTasks(
                            _formData['taskName'],
                            _formData['taskDescription'],
                            pickedDate.toIso8601String().substring(0, 10),
                            time
                                .toString()
                                .replaceAll('TimeOfDay(', '')
                                .replaceAll(')', ''),
                          )
                          .then((_) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Display(model))));
                },
              );
      },
    );
  }

  Widget _buildSizedBox() {
    return SizedBox(
      height: 5,
    );
  }

  _pickDate() async {
    isDatePicked = true;
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  _pickTime() async {
    isTimePicked = true;
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        time = t;
      });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
            backgroundColor: Color(0xff6135bc),
            body: _buildColumn(model.selectedTask),
            bottomNavigationBar: CustonBottomNavigationBar(model));
      },
    );
  }
}
