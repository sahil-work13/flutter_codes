import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../Boxes/boxes.dart';
import '../models/NotesModels.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final Box<Notesmodels> noteBox = Hive.box<Notesmodels>('notes');
  TextEditingController titleController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes App"),centerTitle: true,backgroundColor: Colors.lightBlue,),
      body: 
      ValueListenableBuilder<Box<Notesmodels>>(valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _){
        var data = box.values.toList().cast<Notesmodels>();
            return ListView.builder(itemCount: box.length,itemBuilder:(context, index) {
              return Card(
                child: ListTile(title: Text("Title :- " +data[index].title.toString()),
                  subtitle: Text("Description :- " +data[index].description.toString()),
                  trailing: InkWell(
                      onTap: () {
                        delete(data[index]);
                      },
                      child: Icon(Icons.delete,color: Colors.red,)),
                  leading: InkWell(
                      onTap: () {
                        edit(data[index], data[index].title.toString(), data[index].description.toString());
                      },
                      child: Icon(Icons.edit,color: Colors.black,)),)
              );
            },);
          },)
      ,
      floatingActionButton: FloatingActionButton(onPressed: (){
        ShowDialogBox();
      },
        child: Icon(Icons.add),),
    );
  }

  void delete(Notesmodels model) async{
    await model.delete();
  }

  void edit(Notesmodels model, String title, String description) async {
    titleController.text = title;
    descController.text = description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Notes"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Enter title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: "Enter description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedNote = Notesmodels(
                  title: titleController.text,
                  description: descController.text,
                );

                final box = Boxes.getData();
                box.putAt(model.key, updatedNote); // 🔥 replace old object

                titleController.clear();
                descController.clear();

                Navigator.pop(context);
              },
              child: Text("Edit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> ShowDialogBox() async{
    return showDialog(context: context,
      builder:(context) {
        TextEditingController titleController = new TextEditingController();
        TextEditingController descController = new TextEditingController();
        return Expanded(
          child: AlertDialog(title: Text("Add Notes"),
            content: SingleChildScrollView(
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      TextField(controller: titleController,decoration: InputDecoration(labelText: "Enter title",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
                      SizedBox(height: 15,),
                      TextField(controller: descController,decoration: InputDecoration(labelText: "Enter description",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                final data = Notesmodels(title: titleController.text,description: descController.text);
                final box = Boxes.getData();
                box.add(data);
                //data.save();
                //print(data.title);
                //print(data.description);
                Navigator.pop(context);
              }, child: Text("Add")),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],),
        );
      },);
  }
}
