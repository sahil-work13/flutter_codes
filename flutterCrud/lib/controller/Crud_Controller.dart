import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CrudController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> add(String name, String email) async {
    // DEBUG PRINT: Look at your VS Code/Android Studio console for this!
    print("DEBUG: Received in Controller -> Name: '$name', Email: '$email'");

    if (name.isEmpty) {
      print("DEBUG: STOPPING - Name is empty!");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection("users").add({
        "name": name,
        "email": email,
      }).timeout(Duration(minutes: 5));
      print("SUCCESS: Data sent to Cloud");
    } catch (e) {
      print("ERROR: $e");
    }
  }

  Stream<QuerySnapshot> show() {
    return _firestore.collection("users").orderBy('name').snapshots();
  }

  Future<void> delete(String docId) async{
    try{
      await _firestore.collection('users').doc(docId).delete();
    }catch(e){
      print("Exception occured :- ${e.toString()}");
    }
  }

  Future<void> updates(String docId,String newName,String newEmail) async{
    try{
      await _firestore.collection('users').doc(docId).update({
        "name":newName,
        "email":newEmail
      });
    }catch(e){
      print("Exception occured :- ${e.toString()}");
    }
  }
}