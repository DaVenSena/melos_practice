import 'package:domain/models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Notifier, NotifierProvider;

class SelectedTaskNotifier extends Notifier<TaskModel?> {
  @override
  TaskModel? build() => null;

  void setTask(TaskModel task) => state = task;

  void clearTask() => state = null;
}

final selectedTaskProvider = NotifierProvider<SelectedTaskNotifier, TaskModel?>(
  () => SelectedTaskNotifier(),
);
