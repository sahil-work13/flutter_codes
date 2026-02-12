import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/model/StudentModel.dart';
class Studentservices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addStudent(StudentModel model) async{
    try{
      await _db.collection('student').add(model.toMap());
    }catch(e){
      print("Exception in add student function :- ${e.toString()}");
    }
  }

  Stream<List<StudentModel>> getStudent() {
      return  _db.collection('student').orderBy('name').snapshots().map((snapshot) {
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