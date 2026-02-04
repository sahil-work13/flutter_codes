import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_db/models/todoModel.dart';
import 'package:hive_flutter/adapters.dart';

import '../Boxes/TodoBox.dart';

class Viewtask extends StatefulWidget {
  const Viewtask({super.key});

  @override
  State<Viewtask> createState() => _ViewtaskState();
}

class _ViewtaskState extends State<Viewtask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task"),
          centerTitle: true,
          backgroundColor: Colors.lightBlue),

      body:
      ValueListenableBuilder<Box<Todomodel>>(
        valueListenable: Todobox.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<Todomodel>();
          return ListView.builder(itemCount: box.length,
            itemBuilder: (context, index) {
              return Card(
                child:
                ListTile(
                  title: Text(data[index].task.toString()),
                  subtitle: Text(data[index].description.toString()),
                  trailing: Text(data[index].date.toString()),
                  onLongPress: () {
                     showDialog(context: context, builder:(context) {
                      return AlertDialog(title: Text("Do u want to delete?"),actions: [
                        TextButton(onPressed: (){
                          box.deleteAt(index);
                          Navigator.pop(context);
                        const snack =  SnackBar(content: Text("deleted succesfully"),);
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                        setState(() {

                        });
                        }, child: Text("Yes")),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                          setState(() {

                          });
                        }, child: Text("Cancel")),
                      ],);
                    },);
                  },
                )
                ,
              );
            },);
        },)
      ,
    );
  }


}