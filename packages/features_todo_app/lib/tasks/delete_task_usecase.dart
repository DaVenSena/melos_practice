import 'package:domain/repositories/tasks/task_repo_provider.dart';
import 'package:domain/repositories/tasks/tasks_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;

abstract class DeleteTaskUsecase {
  Future<void> call(int id);
}

class DeleteTaskUsecaseImpl implements DeleteTaskUsecase {
  final TasksRepository tasksRepository;

  DeleteTaskUsecaseImpl({required this.tasksRepository});

  @override
  Future<void> call(int id) async {
    return await tasksRepository.deleteTask(id);
  }
}

final deleteTaskUsecaseProvider = Provider<DeleteTaskUsecase>((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return DeleteTaskUsecaseImpl(tasksRepository: repository);
});
