import 'package:domain/models/task.dart';
import 'package:domain/repositories/tasks/task_repo_provider.dart';
import 'package:domain/repositories/tasks/tasks_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;

abstract class UpdateTaskUsecase {
  Future<void> call(TaskModel task);
}

class UpdateTaskUsecaseImpl implements UpdateTaskUsecase {
  final TasksRepository tasksRepository;

  UpdateTaskUsecaseImpl({required this.tasksRepository});

  @override
  Future<void> call(TaskModel task) async {
    return await tasksRepository.updateTask(task);
  }
}

final updateTaskUsecaseProvider = Provider<UpdateTaskUsecase>((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return UpdateTaskUsecaseImpl(tasksRepository: repository);
});
