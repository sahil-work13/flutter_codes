import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_db/Boxes/TodoBox.dart';
import 'package:hive_db/models/todoModel.dart';

import 'ViewTask.dart';

class Addtask extends StatefulWidget {
  const Addtask({super.key});

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  TextEditingController taskController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  final box = Todobox.getData();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task"),centerTitle: true,backgroundColor: Colors.lightBlue,),

      body:
      Center(
        child: Container(
          width: 300,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(controller: taskController,decoration: InputDecoration(hintText: "Enter task",
                  border:OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),

              SizedBox(height: 20,),

              TextField(controller: descController,decoration: InputDecoration(hintText: "Enter task description",
                  border:OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),

              SizedBox(height: 20,),

              TextField(controller: dateController,decoration: InputDecoration(hintText: "Enter task date",
                  border:OutlineInputBorder(borderRadius: BorderRadius.circular(15))),readOnly: true,
                onTap: () async{
                  selectedDate = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2099));
                  dateController.text = "${selectedDate?.year}/${selectedDate?.month}/${selectedDate?.day}";
                },),

              SizedBox(height: 25,),

              ElevatedButton(onPressed: (){

                print("Data saved");
                setState(() {
                addTask();
                Navigator.push(context, MaterialPageRoute(builder: (context) => Viewtask(),));
                });
              }, child: Text("Add Task")),
            ],
          ),
        ),
      )
      ,
    );
  }
  void addTask(){
    final data = Todomodel(
        task: taskController.text,
        description: descController.text,
        date: selectedDate
    );
    box.add(data);
  }
}

