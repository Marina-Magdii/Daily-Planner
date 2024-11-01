import 'package:daily_planner/core/firebase/firestore_helper.dart';
import 'package:daily_planner/core/firebase/user.dart' as MyUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../style/routes_manager.dart';

class AuthUserProvider extends ChangeNotifier{
  MyUser.User? databaseUser;
  User? fireBUser;

  setUsers (MyUser.User? dbUser, User? firebaseUser){
    databaseUser=dbUser;
    fireBUser=firebaseUser;
  }
  bool isLogged(){
    if(FirebaseAuth.instance.currentUser == null) return false;
    fireBUser=FirebaseAuth.instance.currentUser;
    return true;
  }

 Future<void> retrieveData()async{
    try{
      await FirestoreHelper.getUser(fireBUser!.uid);
    }catch(e){
      print(e);
    }
  }
  Future<void>signOut(BuildContext context)async {
    databaseUser=null;
    fireBUser=null;
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, RoutesManager.loginName, (route) => false);
  }
}