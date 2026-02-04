import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rest_api/models/UserModel.dart';
import 'package:http/http.dart' as http;

class Userview extends StatefulWidget {
  const Userview({super.key});

  @override
  State<Userview> createState() => _UserviewState();
}

class _UserviewState extends State<Userview> {
  List<Usermodel> list = [];
  Future<List<Usermodel>> getUser() async{
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      list.clear();
      for(Map<String,dynamic> i in data){
        list.add(Usermodel.fromJson(i));
      }
      return [];
    }
    else{
      print("Somethig went wrong");
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User View"),centerTitle: true,backgroundColor: Colors.lightBlue,),
      
      body: 
      Column(
        children: [
          Expanded(
            child: FutureBuilder(future: getUser(),
                builder:(context, snapshot) {
                  if(!snapshot.hasData){
                    return Text("Something went wrong in future builder");
                  }
                  else
                    {
                      return ListView.builder(itemCount: list.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child:
                              ListTile(title: Text("User ID :- " +list[index].userId.toString()),
                                subtitle: Text("Task Completion Status :- " +list[index].completed.toString()),
                                trailing: Text("Title :- " +list[index].title.toString()),),
                            );
                          },);
                    }
                },),
          )
        ],
      )
      ,
    );
  }
}
