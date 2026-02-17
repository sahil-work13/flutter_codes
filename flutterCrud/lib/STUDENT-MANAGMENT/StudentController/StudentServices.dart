import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/model/StudentModel.dart';
class Studentservices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  Future<void> addStudent(StudentModel model,String userId) async{
    try{
      
    Map<String, dynamic> data = model.toMap();
    data['userId'] = userId;
    await _db.collection('student').add(data);
    }catch(e){
      print("Exception in add student function :- ${e.toString()}");
    }
  }

 Stream<List<StudentModel>> getStudent() {
  // 1. Get the current user
  User? user = FirebaseAuth.instance.currentUser;

  // 2. If no user is logged in, return an empty list immediately
  if (user == null) {
    return Stream.value([]);
  }

  // 3. Use the user's UID for the query
  return _db
      .collection('student')
      .where("userId", isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data(), doc.id))
        .toList();
  });
}

  Future<void> removeStudent(String id) async{
    try{
      await _db.collection('student').doc(id).delete();
    }catch(e){
      print("Exception in remove student function :- ${e.toString()}");
    }
  }

  Future<void> updateStudent(StudentModel student) async {
    try{
      await _db.collection('student').doc(student.id).update(student.toMap());
    }catch(e){
      print("Exception in update student function :- ${e.toString()}");
    }
  }
}