import 'package:flutter/material.dart';

class Tasks {
  final String taskId;
  final String taskName;
  final String taskDescription;
  final String taskDate;
  final String taskTime;
  final String userEmail;
  final String userId;
  final bool isCompleted;

  Tasks(
      {@required this.taskName,
      this.taskDescription,
      this.taskDate,
      this.taskTime,
      @required this.taskId,
      @required this.userEmail,
      @required this.userId,
      this.isCompleted = false});
}
