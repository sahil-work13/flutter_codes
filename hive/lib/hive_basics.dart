import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveBasics extends StatefulWidget {
  const HiveBasics({super.key});

  @override
  State<HiveBasics> createState() => _HiveBasicsState();
}

class _HiveBasicsState extends State<HiveBasics> {
  late Future<Box> boxfuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    boxfuture = Hive.openBox('sk');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hive Basics"),centerTitle:  true,backgroundColor: Colors.lightBlue,),

      body:
      Column(
        children: [
          Expanded(
            child: FutureBuilder(future: boxfuture,
                builder: (context, snapshot){
                final box = snapshot.data!;
                  return Column(
                    children: [
                      Text(box.get('name',defaultValue: 'No value')),
                      Text(box.get('age',defaultValue: 'No value').toString()),
                      Text(box.get('role',defaultValue: 'No value')),
                    ],
                  );
                },),
          ),
          FloatingActionButton(onPressed: () async{
            var box = await Hive.openBox("sk");
            box.put('name', 'sahil');
            box.put('age', 22);
            box.put('role',"dev");
            setState(() {

            });
          },child: Icon(Icons.add),)
        ],
      )
      ,
    );
  }
}
