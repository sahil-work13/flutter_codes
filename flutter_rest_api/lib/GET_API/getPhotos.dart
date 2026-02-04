import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_rest_api/models/photos_model.dart';

class Getphotos extends StatefulWidget {
  const Getphotos({super.key});

  @override
  State<Getphotos> createState() => _GetphotosState();
}

class _GetphotosState extends State<Getphotos> {
  List<PhotosModel> list = [];
  
  Future<List<PhotosModel>> getPhotoApi() async{
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(response.body.toString());

    if(response.statusCode == 200){
      list.clear();
      for(Map<String,dynamic> i in data){
        list.add(PhotosModel.fromJson(i));
      }
      return list;
    }
    else{
      return list;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Get Photos Api"),centerTitle: true,backgroundColor: Colors.lightBlue,),
      
      body: 
      Column(
        children: [
          Expanded(
              child:
              FutureBuilder(future: getPhotoApi(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {

                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.pinkAccent,
                        ),
                      );
                    }
                    else{
                      Future.delayed(Duration(seconds: 30));
                      return ListView.builder(itemCount: list.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child:
                              Column(
                                children: [
                                  Text(" Album Id :- " +list[index].albumId.toString()),
                                  Text(" Id :- " +list[index].id.toString()),
                                  Text(" Title :- " +list[index].title.toString()),
                                  Text(" Album Id :- " +list[index].url.toString()),
                                ],
                              )
                              ,
                            );
                          },);
                    }
                  },)
          )
        ],
      )
      ,
    );
  }
}
