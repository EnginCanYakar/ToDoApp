import 'package:hive/hive.dart';

part 'Todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String time;

  @HiveField(3)
  final String date;

  @HiveField(4)
  final int priority;

  Todo({
    required this.title,
    required this.description,
    required this.time,
    required this.date,
    required this.priority,
  });
}
