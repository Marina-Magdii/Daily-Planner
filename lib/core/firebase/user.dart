class User {
  static const String collectionName= "Users";
  String? id;
  String? name;
  String? email;
  User({required this.name,required this.id,required this.email});
  User.fromFirestore(Map <String, dynamic> data){
    id = data['id'];
    name = data['name'];
    email = data['email'];
  }
  Map<String, dynamic> toFirestore(){
    return {
      'id': id,
      'name': name,
      'email': email
    };
  }
}