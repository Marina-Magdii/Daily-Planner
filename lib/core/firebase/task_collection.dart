import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/firebase/firestore_helper.dart';
import 'package:daily_planner/core/firebase/task.dart';

class TaskCollection {
  static CollectionReference<Task> getTaskCollection(String userId) {
    var userCollection = FirestoreHelper.getUsersCollection();
    var userDoc = userCollection.doc(userId);
    var taskCollection = userDoc.collection(Task.collectionName).withConverter(
          fromFirestore: (snapshot, options) =>
              Task.fromFirestore(snapshot.data() ?? {}),
          toFirestore: (task, options) => task.toFirestore(),
        );
    return taskCollection;
  }

  static Future<void> createTask(String userId, Task newTask) async {
    var reference = getTaskCollection(userId);
    var docs = reference.doc();
    newTask.id = docs.id;
    await docs.set(newTask);
  }

  static Future<List<Task>> getTasks(String userId, DateTime date) async {
    var reference = getTaskCollection(userId);
    var snapshot = await reference
        .where("date",
            isEqualTo: Timestamp.fromMillisecondsSinceEpoch(
                date.millisecondsSinceEpoch))
        .get();
    var list = snapshot.docs.map((e) => e.data()).toList();
    return list;
  }

  static Future<void> updateTask(String userId, Task updatedTask) async {
    var reference = getTaskCollection(userId);
    var doc = reference.doc(updatedTask.id);
    await doc.update(updatedTask.toFirestore());
  }

  static Future<void> deleteTask(String userId, String taskId) async {
    var reference = getTaskCollection(userId);
    var doc = reference.doc(taskId);
    await doc.delete();
  }
}
