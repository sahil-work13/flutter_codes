import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';


class AddproductApi extends StatefulWidget {
  const AddproductApi({super.key});

  @override
  State<AddproductApi> createState() => _AddproductApiState();
}

class _AddproductApiState extends State<AddproductApi> {
  File? image ;
  final _picker = ImagePicker();
  bool showSpinner = false ;
  File? mobileImageFile;       // Android / iOS
  Uint8List? webImageBytes;

  Future<void> getImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null) {
        setState(() {
          webImageBytes = result.files.first.bytes;
        });
      }
    } else {
      final XFile? image =
      await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          mobileImageFile = File(image.path);
        });
      }
    }
  }


  Future<void> uploadImage ()async{

    setState(() {
      showSpinner = true ;
    });

    var stream  = new http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();

    var uri = Uri.parse('https://fakestoreapi.com/products');

    var request = new http.MultipartRequest('POST', uri);

    request.fields['title'] = "Static title" ;

    var multiport = new http.MultipartFile(
        'image',
        stream,
        length);

    request.files.add(multiport);

    var response = await request.send() ;

    print(response.stream.toString());
    if(response.statusCode == 200){
      setState(() {
        showSpinner = false ;
      });
      print('image uploaded');
    }else {
      print('failed');
      setState(() {
        showSpinner = false ;
      });

    }

  }

  Future<void> addProduct() async {
    print("🔥 addProduct() CALLED");

    final url = Uri.parse("https://fakestoreapi.com/products");

    final body = {
      "title": title.text.trim(),
      "description": desc.text.trim(),
      "price": int.tryParse(price.text) ?? 0,
      "id": id.text.trim(),
      "category": category.text.trim(),
      "image": imageurl.text.trim(),
    };

    print("📦 REQUEST BODY: $body");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("📥 STATUS CODE: ${response.statusCode}");
      print("📥 RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Product added successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Failed: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ EXCEPTION: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  TextEditingController id = new TextEditingController();
  TextEditingController title = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController desc = new TextEditingController();
  TextEditingController category = new TextEditingController();
  TextEditingController imageurl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(inAsyncCall: showSpinner,
        child: Scaffold(
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

    TextFormField(controller: title,decoration: InputDecoration(hintText: "Enter title",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
    SizedBox(height: 30,),

    TextFormField(controller: price,decoration: InputDecoration(hintText: "Enter price",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
    SizedBox(height: 30,),

    TextFormField(controller: desc,decoration: InputDecoration(hintText: "Enter description",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
    SizedBox(height: 30,),

    TextFormField(controller: category,decoration: InputDecoration(hintText: "Enter category",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
    SizedBox(height: 30,),

      TextField(
        controller: imageurl,
        decoration: const InputDecoration(
          labelText: "Image URL",
          hintText: "https://example.com/image.png",
          border: OutlineInputBorder(),
        ),
        onChanged: (_) {
          setState(() {}); // refresh preview
        },
      ),
    SizedBox(height: 30,),
    ElevatedButton(onPressed: () {
      addProduct();
    },child: Text("Add Product"))],
    ),
    ),
    )
    ,
    ));
  }
}
