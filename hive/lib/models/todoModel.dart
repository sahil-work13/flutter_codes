import 'package:hive/hive.dart';
part 'todoModel.g.dart';
@HiveType(typeId: 1)
class Todomodel extends HiveObject{
  @HiveField(0)
  final String? task;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final DateTime? date;

  Todomodel({this.task, this.description, this.date});

}