import 'package:hive/hive.dart';
import 'package:hive_db/models/NotesModels.dart';

class Boxes{
  static Box<Notesmodels> getData() => Hive.box<Notesmodels>('notes');
}