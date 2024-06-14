import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/taskmodel.dart';

class TaskServices {
  CollectionReference _taskcollection =
      FirebaseFirestore.instance.collection("tasks");

//create a task

  Future<Taskmodel?> createTask(Taskmodel task) async {
    try {
      final taskmap = task.tomap();
      await _taskcollection.doc(task.id).set(taskmap);
      return task;
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

//getall tasks
  Stream<List<Taskmodel>> getallTasks(String uid) {
    try {
      return _taskcollection.where('userid',isEqualTo: uid).snapshots().map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot doc) {
          return Taskmodel.fromjson(doc);
        }).toList();
      });
    } on FirebaseException catch (e) {
      print(e);
      throw (e);
    }
  }

//update tasks

  Future<void> updateTask(Taskmodel task) async {
    try {
      final taskmap = task.tomap();
      await _taskcollection.doc(task.id).update(taskmap);
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

//delete tasks

  Future<void> deleteTask(String? id) async {
    try {
      await _taskcollection.doc(id).delete();
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }
}
