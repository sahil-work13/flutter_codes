import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteproductApi extends StatefulWidget {
  const DeleteproductApi({super.key});

  @override
  State<DeleteproductApi> createState() => _DeleteproductApiState();
}

class _DeleteproductApiState extends State<DeleteproductApi> {
  TextEditingController id = new TextEditingController();
  Future<void> delete(int id) async{
    try{
      print("Deleting..");

      final url = Uri.parse('https://fakestoreapi.com/products/$id');
      final response = await http.delete(url);
      if(response.statusCode == 200){
        print("Product deleted Succesfully");
      }
      else{
        print("something went wrong");
      }
    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product"),centerTitle: true,backgroundColor: Colors.lightBlue,),

      body:
      Center(
        child: Container(
        width: 300,
        height: 500,
        child: Column(
          children: [
          TextFormField(controller: id,decoration: InputDecoration(hintText: "Enter id",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
        SizedBox(height: 30,),
          ElevatedButton(onPressed: (){
            final int productId = int.parse(id.text);
            delete(productId);
          }, child: Text("Delete Product"))
          ]),),)
      ,
    );
  }
}
