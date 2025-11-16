import 'package:data/data_source/base_data_source.dart';
import 'package:data/repositories/users_repo_impl.dart';
import 'package:domain/repositories/users/users_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  final dataSource = ref.watch(localDataSourceProvider);
  return UsersRepoImpl(dataSource: dataSource);
});
