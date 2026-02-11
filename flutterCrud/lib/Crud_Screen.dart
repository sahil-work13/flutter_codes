import 'package:flutter/material.dart';
import 'package:fluttercrud/controller/Crud_Controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();
  final CrudController controller = Get.put(CrudController());

  void _showEditDialog(String docId, String currentName, String currentEmail) {
    final nameEditController = TextEditingController(text: currentName);
    final emailEditController = TextEditingController(text: currentEmail);

    Get.defaultDialog(
        title: "Edit User",
        content: Column(
          children: [
            TextField(controller: nameEditController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: emailEditController, decoration: const InputDecoration(labelText: "Email")),
          ],
        ),
        textConfirm: "Update",
        onConfirm: () {
          controller.updates(
              docId,
              nameEditController.text.trim(),
              emailEditController.text.trim()
          );
          Get.back(); // Close dialog
        },
        textCancel: "Cancel"
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("FireBase Crud"),centerTitle: true,backgroundColor: Colors.lightBlue,),

      body:
      Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(controller: name,decoration: InputDecoration(labelText: "Enter name",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
              SizedBox(height: 18,),

              TextField(controller: email,decoration: InputDecoration(labelText: "Enter email",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
              SizedBox(height: 18,),

              ElevatedButton(onPressed: () async {
                await controller.add(name.text.trim(), email.text.trim());
                print("data added");
                print("UI level check: ${name.text}");
                setState(() {
                name.clear();
                email.clear();
                });
              }, child: Text("Add")),
              SizedBox(height: 40,),

              Expanded(
                  child:
                  StreamBuilder(stream: controller.show(), builder: (context, snapshot) {
                      if(snapshot.hasError){
                        return const Center(child: Text("Something went wrong"),);
                      }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(child: const CircularProgressIndicator());
                      }
                      if(snapshot.data!.docs.isEmpty){
                        return const Center(child: Text("No users found"),);
                      }

                      return ListView.builder(shrinkWrap: true,itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var doc = snapshot.data!.docs[index];
                            Map<String,dynamic> user = doc.data() as Map<String,dynamic>;
                            return ListTile(
                              onTap: () {
                                _showEditDialog(doc.id, user['name'], user['email']);
                              },
                              leading: CircleAvatar(child: Icon(Icons.person),),
                              title:  Text(user['name'] ?? 'No name'),
                              subtitle: Text(user['email'] ?? 'Email not available'),
                              trailing:  InkWell(
                                onTap: () {
                                  controller.delete(doc.id);
                                },
                                  child: Icon(Icons.delete,color: Colors.red,)),
                            );
                          },);
                  },),
              )
            ],
          ),
        ),
      )
      ,
    );
  }
}
