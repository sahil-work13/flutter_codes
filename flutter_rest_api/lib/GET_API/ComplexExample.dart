import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_rest_api/models/complex_model.dart';

class Complexexample extends StatefulWidget {
  const Complexexample({super.key});

  @override
  State<Complexexample> createState() => _ComplexexampleState();
}

class _ComplexexampleState extends State<Complexexample> {
  
  Future<ComplexModel> getComplexData() async{
    var response = await http.get(Uri.parse("https://webhook.site/889bab9c-8749-448d-a86c-3259e9cfc3d4"));
    var data = jsonDecode(response.body.toString());

    if(response.statusCode == 200){
      return ComplexModel.fromJson(data);
    }
    else
      {
        return ComplexModel.fromJson(data);
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products"),centerTitle: true,backgroundColor: Colors.lightBlue,),

      body:
      Column(
        children: [
          Expanded(
            child: FutureBuilder<ComplexModel>(future: getComplexData(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Text("Loading");
                  }
                  else
                    {
                      return ListView.builder(itemCount: snapshot.data!.data!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(snapshot.data!.data![index].shop!.name.toString()),
                                  subtitle: Text(snapshot.data!.data![index].shop!.shopemail.toString()),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot.data!.data![index].shop!.image.toString()),
                                  )
                                ),

                                Container(
                                  height: MediaQuery.of(context).size.height *.3,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child:
                                  ListView.builder(itemCount: snapshot.data!.data![index].images!.length,
                                      itemBuilder:(context, index) {
                                        return Container(
                                          height: MediaQuery.of(context).size.height *.25,
                                          width: MediaQuery.of(context).size.width * .5,
                                          decoration:
                                          BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(fit: BoxFit.cover,
                                                image: NetworkImage(snapshot.data!.data![index].images![index].toString()))
                                          )
                                          ,
                                        );
                                      },)
                                  ,
                                )
                              ],
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
