import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Sharedpreference extends StatefulWidget {
  const Sharedpreference({super.key});

  @override
  State<Sharedpreference> createState() => _SharedpreferenceState();
}

class _SharedpreferenceState extends State<Sharedpreference> {
  TextEditingController name = new TextEditingController();
  var nameVal = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvalue();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shared Preference"),centerTitle: true,backgroundColor: Colors.lightBlue,),

      body:
      Column(
        children: [
          TextField(controller: name,decoration: InputDecoration(labelText: "Enter name",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
          SizedBox(height: 15,),
          ElevatedButton(onPressed: () async{
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('name', name.text);
          }, child: Text("Save name")),
          SizedBox(height: 15,),
          Text(nameVal)
        ],
      )
      ,
    );
  }
  void getvalue() async{
    var prefs = await SharedPreferences.getInstance();
    var getName=prefs.getString('name');

    nameVal = getName != null ? getName : "No name saved";
    setState(() {

    });
  }
}