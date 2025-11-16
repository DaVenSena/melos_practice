class TaskEntity {
  final int? id;
  final int userId, isDone;
  final String title, description;
  DateTime? createdAt, updatedAt;

  TaskEntity({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.isDone = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      isDone: json['isDone'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'isDone': isDone,
    };

    if (createdAt != null) {
      map['createdAt'] = createdAt!.toLocal().toIso8601String();
    }

    if (updatedAt != null) {
      map['updatedAt'] = updatedAt!.toLocal().toIso8601String();
    }

    return map;
  }

  TaskEntity copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    int? isDone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      TaskEntity(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description ?? this.description,
        isDone: isDone ?? this.isDone,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
