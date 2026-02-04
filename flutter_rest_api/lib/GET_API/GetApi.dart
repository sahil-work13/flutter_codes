import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_rest_api/models/post_model.dart';

class Getapi extends StatefulWidget {
  const Getapi({super.key});

  @override
  State<Getapi> createState() => _GetapiState();
}

class _GetapiState extends State<Getapi> {
  List<PostModel> list = [];

  Future<List<PostModel>> getPostapi() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      list.clear();
      for (Map<String, dynamic> i in data) {
        list.add(PostModel.fromJson(i));
      }
      return list;
    } else {
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Api"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),

      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getPostapi(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading");
                } else {
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Expanded(
                          child: Column(
                            children: [
                              Text("User Id:-" + list[index].userId.toString()),
                              Text("Title:-" + list[index].title.toString()),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
