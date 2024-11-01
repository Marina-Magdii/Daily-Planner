import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  static const String collectionName = "Tasks";
  String? id;
  String? title;
  Timestamp? date;
  bool? done;
  Task({ this.title, this.id,  this.date ,this.done=false});
  Task.fromFirestore(Map<String, dynamic> map){
    id=map["id"];
    title=map["title"];
    date=map["date"];
    done=map["done"];
  }
  Map<String,dynamic> toFirestore(){
    return {
      "id": id,
      "title": title,
      "date": date,
      "done": done,
    };
  }
}