import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/firebase/user.dart';

class FirestoreHelper {
  static CollectionReference<User> getUsersCollection (){
    var reference =
    FirebaseFirestore.instance.collection(User.collectionName).withConverter(
        fromFirestore: (snapshot, options) {
          Map<String, dynamic>? data = snapshot.data();
          return User.fromFirestore(data??{});
        },
        toFirestore: (user, options) {
          return user.toFirestore();
        });
    return reference;
  }

  static addUser({required String name, required String email, required String userId})async {
    var reference = getUsersCollection();
    var docs = reference.doc(userId);
    await docs.set(
      User(
          name: name,
          id: userId,
          email: email)
    );
  }

  static Future<User?> getUser(String userId) async {
    var reference = getUsersCollection();
    var doc = await reference.doc(userId).get();
    var user = doc.data();
    return user;
  }
}
