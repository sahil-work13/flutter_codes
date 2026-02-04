import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_db/models/NotesModels.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import 'NOTES-APP/HomeScreen.dart';
import 'SIMPLE-SHARED-PREFERENCE-PRACTICE/Splash.dart';
import 'TODO-APP/AddTask.dart';
import 'TODO-APP/SplashScreen.dart';
import 'hive_basics.dart';
import 'models/todoModel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(TodomodelAdapter());
  await Hive.openBox<Todomodel>("todo");

  runApp(MaterialApp(home: Splash(),debugShowCheckedModeBanner: false,));
}
