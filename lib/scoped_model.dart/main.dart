import 'package:scoped_model/scoped_model.dart';
import 'package:to_do_task/models/tasks.dart';
import 'package:to_do_task/models/user_auth.dart';
import 'package:to_do_task/scoped_model.dart/connected_task.dart';


class MainModel extends Model with ConnectedModel, TaskModel, UtilityModel, UserModel{}