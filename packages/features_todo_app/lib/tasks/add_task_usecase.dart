import 'package:domain/models/task.dart';
import 'package:domain/repositories/tasks/task_repo_provider.dart';
import 'package:domain/repositories/tasks/tasks_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;

abstract class AddTaskUsecase {
  Future<void> call(TaskModel task);
}

class AddTaskUsecaseImpl implements AddTaskUsecase {
  final TasksRepository tasksRepository;

  AddTaskUsecaseImpl({required this.tasksRepository});

  @override
  Future<void> call(TaskModel task) async {
    return await tasksRepository.addTask(task);
  }
}

final addTaskUsecaseProvider = Provider<AddTaskUsecase>((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return AddTaskUsecaseImpl(tasksRepository: repository);
});
