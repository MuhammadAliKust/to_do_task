import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:to_do_task/models/tasks.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_task/models/user_auth.dart';
import 'package:to_do_task/models/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectedModel extends Model {
  List<Tasks> _taskList = [];
  List<UserDetails> _detailsList = [];
  bool _isLoading = false;
  String _selTasksId;
  UserAuth _authenticatedUser;
  UserDetails _details;
}

class TaskModel extends ConnectedModel {
  bool _showCompleted = false;

  List<Tasks> get allTasks {
    return List.from(_taskList);
  }

  List<UserDetails> get allUsers {
    return List.from(_detailsList);
  }

  List<Tasks> get displayedCompletedTasks {
    if (_showCompleted) {
      return _taskList.where((Tasks tasks) => tasks.isCompleted).toList();
    }
    return List.from(_taskList);
  }

  void selectTask(String index) {
    _selTasksId = index;
    notifyListeners();
  }

  String get selectedTaskId {
    return _selTasksId;
  }

  Tasks get selectedTask {
    if (selectedTaskId == null) {
      return null;
    }

    return _taskList.firstWhere((Tasks tasks) {
      return tasks.taskId == _selTasksId;
    });
  }

  bool get displayCompletedTasksOnly {
    return _showCompleted;
  }

  int get selectedTaskIndex {
    return _taskList.indexWhere((Tasks tasks) {
      return tasks.taskId == _selTasksId;
    });
  }

  Future<bool> addUserDetails(String username, String email) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> userDetails = {
      'username': username,
      'email': email,
    };
    try {
      final http.Response response = await http.post(
          'https://intro-to-firebase-711d4.firebaseio.com/Users.json',
          body: json.encode(userDetails));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      _details = UserDetails(
          userDetailsId: responseData['name'], name: username, email: email);

      _detailsList.add(_details);
      print("User Details ID");
      print(_details.userDetailsId);
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchUserID() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://intro-to-firebase-711d4.firebaseio.com/Users.json')
        .then<Null>((http.Response response) {
      final List<UserDetails> fetchUserIdList = [];
      final Map<String, dynamic> fetchUserId = json.decode(response.body);
     
      if (fetchUserId == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      fetchUserId.forEach((String userID, dynamic userData) {
        print("User Data");
        print(userData);

        _details = UserDetails(
            userDetailsId: userID,
            name: userData['username'],
            email: userData['email']);

        fetchUserIdList.add(_details);
      });
      _detailsList = fetchUserIdList.where((UserDetails userDetails) {
        return userDetails.email == _authenticatedUser.email;
      }).toList();

      print("All Users");
      print(allUsers.length);
      print(allUsers[0].userDetailsId);
      print(allUsers[0].name);
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<bool> addTasks(String taskName, String taskDescription,
      String taskDate, String taskTime) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> taskData = {
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskDate': taskDate,
      'taskTime': taskTime,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    try {
      final http.Response response = await http.post(
          'https://intro-to-firebase-711d4.firebaseio.com/Users/${_detailsList[0].userDetailsId}/Tasks.json?auth=${_authenticatedUser.token}',
          // 'https://intro-to-firebase-711d4.firebaseio.com/Tasks.json?auth=${_authenticatedUser.token}',
          body: json.encode(taskData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      print("Response Data Add Data : $responseData}");
      Tasks _tasks = Tasks(
          taskName: taskName,
          taskDate: taskDate,
          taskTime: taskTime,
          taskId: responseData['name'],
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _taskList.add(_tasks);
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchTasks({onlyForUser: false}) async {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
      'https://intro-to-firebase-711d4.firebaseio.com/Users/${_detailsList[0].userDetailsId}/Tasks.json?auth=${_authenticatedUser.token}',
    )
        .then<Null>((http.Response response) {
      final List<Tasks> fetchedTasksList = [];
      final Map<String, dynamic> fetchedTask = json.decode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (fetchedTask == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      print("Fetched Task List");
      print(fetchedTask);
      print("============");
      fetchedTask.forEach((String taskId, dynamic taskData) {
        final Tasks tasks = Tasks(
            taskId: taskId,
            taskName: taskData['taskName'],
            taskDescription: taskData['taskDescription'],
            taskDate: taskData['taskDate'],
            taskTime: taskData['taskTime'],
            userEmail: taskData['userEmail'],
            userId: taskData['userId'],
            isCompleted: taskData['CompletedTasks'] == null
                ? false
                : (taskData['CompletedTasks'] as Map<String, dynamic>)
                    .containsKey('1234567899'));
        fetchedTasksList.add(tasks);
      });
      _taskList = fetchedTasksList.where((Tasks tasks) {
        return tasks.userId == _authenticatedUser.id;
      }).toList();
      print("My Data ");
      print("My Data ");
      _isLoading = false;
      notifyListeners();
      print(fetchedTasksList.length);
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<bool> updateTask(String taskName, String taskDescription,
      String taskDate, String taskTime) {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updatedTask = {
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskDate': taskDate,
      'taskTime': taskTime,
      'userEmail': selectedTask.userEmail,
      'userId': selectedTask.userId
    };

    return http
        .put(
            'https://intro-to-firebase-711d4.firebaseio.com/Users/${_detailsList[0].userDetailsId}/Tasks/${selectedTask.taskId}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updatedTask))
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      final Tasks updateTask = Tasks(
          taskName: taskName,
          taskId: selectedTask.taskId,
          userEmail: selectedTask.userEmail,
          userId: selectedTask.userId,
          taskDate: taskDate,
          taskTime: taskTime);
      _taskList[selectedTaskIndex] = updateTask;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteTask() {
    _isLoading = true;
    final deletedTaskId = selectedTask.taskId;
    print("Deleted Task ID : $deletedTaskId");
    _taskList.removeAt(selectedTaskIndex);
    print("Selected Task Index : $selectedTaskIndex");
    notifyListeners();
    print(allTasks.length);
    _selTasksId = null;
    notifyListeners();
    return http
        .delete(
            'https://intro-to-firebase-711d4.firebaseio.com/Users/${_detailsList[0].userDetailsId}/Tasks/${deletedTaskId}.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      print(error);
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void toggleTasksCompletedStatus() async {
    final bool isCurrentlyCompleted = selectedTask.isCompleted;
    final bool newCompletedStatus = !isCurrentlyCompleted;
    final Tasks updatedTask = Tasks(
        taskId: selectedTask.taskId,
        taskName: selectedTask.taskName,
        taskDescription: selectedTask.taskDescription,
        taskDate: selectedTask.taskDate,
        taskTime: selectedTask.taskTime,
        userEmail: selectedTask.userEmail,
        userId: selectedTask.userId,
        isCompleted: newCompletedStatus);
    _taskList[selectedTaskIndex] = updatedTask;
    notifyListeners();
    http.Response response;
    if (newCompletedStatus) {
      response = await http.put(
          'https://intro-to-firebase-711d4.firebaseio.com/Users/${_detailsList[0].userDetailsId}/Tasks/${selectedTask.taskId}/CompletedTasks/1234567899.json',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://intro-to-firebase-711d4.firebaseio.com/Users/${_detailsList[0].userDetailsId}/Tasks/${selectedTask.taskId}/CompletedTasks/1234567899.json');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      final Tasks updatedTask = Tasks(
          taskId: selectedTask.taskId,
          taskName: selectedTask.taskName,
          taskDescription: selectedTask.taskDescription,
          taskDate: selectedTask.taskDate,
          taskTime: selectedTask.taskTime,
          userEmail: selectedTask.userEmail,
          userId: selectedTask.userId,
          isCompleted: !newCompletedStatus);
      _taskList[selectedTaskIndex] = updatedTask;
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showCompleted = !_showCompleted;
    notifyListeners();
  }
}

class UserModel extends ConnectedModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  UserAuth get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }

  Future<Map<String, dynamic>> signUp(
      String email, String password, bool isLogin) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response response;
    isLogin
        ? response = await http.post(
            'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDNQzOBix-VPkh9JGMC-vLjW9i3yR2MYSM',
            body: json.encode(authData),
            headers: {
                'Content-Type': 'application/json'
              })
        : response = await http.post(
            'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDNQzOBix-VPkh9JGMC-vLjW9i3yR2MYSM',
            body: json.encode(authData),
            headers: {'Content-Type': 'application/json'});
    ;

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeed!';
      _isLoading = false;
      notifyListeners();
      _authenticatedUser = UserAuth(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Email not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Invalid password.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = UserAuth(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    print('Logout');
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
    _taskList.clear();
  }
}

class UtilityModel extends ConnectedModel {
  bool get isLoading {
    return _isLoading;
  }
}
