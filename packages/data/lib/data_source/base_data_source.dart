import 'package:data/data_source/db/local_ds_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;

import '../entities/entities.dart';

abstract class BaseDataSource {
  Future<List<TaskEntity>> getTasks(int userId);
  Future<bool> addTask(TaskEntity task);
  Future<bool> updateTask(TaskEntity task);
  Future<bool> deleteTask(int id);
  Future<UserEntity?> signIn(String username);
  Future<UserEntity?> signUp(String username, String password);
}

final localDataSourceProvider = Provider<BaseDataSource>((ref) {
  return LocalDataSource();
});
