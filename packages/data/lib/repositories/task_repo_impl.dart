import 'package:data/data_source/base_data_source.dart';
import 'package:domain/models/task.dart';
import 'package:domain/repositories/tasks/tasks_repo.dart';

class TasksRepoImpl implements TasksRepository {
  final BaseDataSource dataSource;

  TasksRepoImpl({required this.dataSource});

  @override
  Future<List<TaskModel>> getTasks(int userId) async {
    final tasks = await dataSource.getTasks(userId);
    return tasks.map((task) => TaskModel.fromEntity(task)).toList();
  }

  @override
  Future<bool> addTask(TaskModel task) async {
    return await dataSource.addTask(task.toEntity());
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await dataSource.updateTask(task.toEntity());
    return;
  }

  @override
  Future<void> deleteTask(int id) async {
    await dataSource.deleteTask(id);
    return;
  }
}
