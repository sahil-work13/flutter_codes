import 'package:hive/hive.dart';
import 'package:hive_db/models/todoModel.dart';

class Todobox {
  static Box<Todomodel> getData() => Hive.box<Todomodel>('todo');
}