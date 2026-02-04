import 'package:hive/hive.dart';
part 'NotesModels.g.dart';

@HiveType(typeId: 0)
class Notesmodels extends HiveObject{

  @HiveField(0)
  final String? title;

  @HiveField(1)
  final String? description;

  Notesmodels({this.title, this.description});


}