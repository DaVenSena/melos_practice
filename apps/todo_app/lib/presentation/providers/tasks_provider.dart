import 'package:domain/models/task.dart';
import 'package:features_todo_app/use_cases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show
        ProviderListenableSelect,
        AsyncNotifier,
        AsyncNotifierProvider,
        AsyncValue,
        AsyncData;
import 'package:todo_app/presentation/providers/user_provider.dart';

class TasksNotifier extends AsyncNotifier<List<TaskModel>> {
  int _temporaryIdSeed = -1;

  int _generateTemporaryId() => _temporaryIdSeed--;

  List<TaskModel> _currentTasksSnapshot() {
    final currentState = state;
    if (currentState is AsyncData<List<TaskModel>>) {
      return List<TaskModel>.from(currentState.value);
    }
    return <TaskModel>[];
  }

  @override
  Future<List<TaskModel>> build() async {
    final userId = ref.watch(
      userProvider.select(
        (state) => (state is UserAuthenticated) ? state.user.id! : null,
      ),
    );
    if (userId == null) return [];
    return await _getTasksUsecase(userId);
  }

  int? get _userId => ref.read(
        userProvider.select(
          (state) => (state is UserAuthenticated) ? state.user.id! : null,
        ),
      );
  GetTasksUsecase get _getTasksUsecase => ref.read(getTasksUsecaseProvider);
  AddTaskUsecase get _addTaskUsecase => ref.read(addTaskUsecaseProvider);
  UpdateTaskUsecase get _updateTaskUsecase =>
      ref.read(updateTaskUsecaseProvider);
  DeleteTaskUsecase get _deleteTaskUsecase =>
      ref.read(deleteTaskUsecaseProvider);

  Future<void> getTasks() async {
    final userId = _userId;
    if (userId == null) {
      state = const AsyncValue.data([]);
      return;
    }
    state = await AsyncValue.guard(() => _getTasksUsecase(userId));
  }

  Future<void> addTask(TaskModel task) async {
    if (_userId == null) return;
    final previousState = state;
    final currentTasks = _currentTasksSnapshot();
    final optimisticTask = TaskModel(
      id: _generateTemporaryId(),
      userId: task.userId,
      title: task.title,
      description: task.description,
      isDone: task.isDone,
      createdAt: task.createdAt ?? DateTime.now(),
      updatedAt: task.updatedAt,
    );
    state = AsyncValue.data([
      ...currentTasks,
      optimisticTask,
    ]);
    try {
      await _addTaskUsecase(task);
      await getTasks();
    } catch (error, stackTrace) {
      state = previousState;
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> updateTask(TaskModel task) async {
    if (_userId == null) return;
    if (task.id == null) {
      await _updateTaskUsecase(task);
      await getTasks();
      return;
    }
    final previousState = state;
    final tasks = _currentTasksSnapshot();
    final index = tasks.indexWhere((element) => element.id == task.id);
    if (index == -1) {
      await _updateTaskUsecase(task);
      await getTasks();
      return;
    }
    tasks[index] = task;
    state = AsyncValue.data(tasks);
    try {
      await _updateTaskUsecase(task);
    } catch (error, stackTrace) {
      state = previousState;
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> deleteTask(int id) async {
    if (_userId == null) return;
    final previousState = state;
    final updatedTasks = _currentTasksSnapshot()
      ..removeWhere((task) => task.id == id);
    state = AsyncValue.data(updatedTasks);
    try {
      await _deleteTaskUsecase(id);
    } catch (error, stackTrace) {
      state = previousState;
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}

final tasksNotifierProvider =
    AsyncNotifierProvider<TasksNotifier, List<TaskModel>>(
  () => TasksNotifier(),
);
