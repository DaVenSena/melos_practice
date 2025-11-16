import 'package:data/data_source/base_data_source.dart';
import 'package:data/repositories/task_repo_impl.dart';
import 'package:domain/repositories/tasks/tasks_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;

final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  final dataSource = ref.watch(localDataSourceProvider);
  return TasksRepoImpl(dataSource: dataSource);
});
