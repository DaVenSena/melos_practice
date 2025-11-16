import 'package:domain/models/task.dart';
import 'package:domain/repositories/tasks/task_repo_provider.dart';
import 'package:domain/repositories/tasks/tasks_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;

abstract class GetTasksUsecase {
  Future<List<TaskModel>> call(int userId);
}

class GetTasksUsecaseImpl implements GetTasksUsecase {
  final TasksRepository tasksRepository;

  GetTasksUsecaseImpl({required this.tasksRepository});

  @override
  Future<List<TaskModel>> call(int userId) async {
    return await tasksRepository.getTasks(userId);
  }
}

final getTasksUsecaseProvider = Provider<GetTasksUsecase>((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return GetTasksUsecaseImpl(tasksRepository: repository);
});
