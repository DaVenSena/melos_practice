import 'package:data/entities/task.dart';

class TaskModel {
  final int? id;
  final int userId;
  final String title, description;
  final bool isDone;
  final DateTime? createdAt, updatedAt;

  TaskModel({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.isDone = false,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      description: entity.description,
      isDone: entity.isDone == 1,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      userId: userId,
      title: title,
      description: description,
      isDone: isDone ? 1 : 0,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
