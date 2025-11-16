import 'package:domain/models/task.dart';

abstract class TasksRepository {
  Future<List<TaskModel>> getTasks(int userId);
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(int id);
}
