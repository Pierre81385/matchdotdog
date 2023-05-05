import 'package:cloud_firestore/cloud_firestore.dart';

class Dog {
  String id;
  String owner;
  String photo;
  String name;
  int gender;
  double size;
  double activity;
  double age;
  List<dynamic> buddies;

  Dog(
      {required this.id,
      required this.owner,
      required this.photo,
      required this.name,
      required this.gender,
      required this.size,
      required this.activity,
      required this.age,
      required this.buddies});

  Dog.fromJson(QueryDocumentSnapshot<Object?>? json)
      : id = json!['id'],
        owner = json!['owner'],
        photo = json['photo'],
        name = json['name'],
        gender = json['gender'],
        size = json['size'],
        activity = json['activity'],
        age = json['age'],
        buddies = json['buddies'];

  factory Dog.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Dog(
        id: data?['id'],
        owner: data?['owner'],
        photo: data?['photo'],
        name: data?['name'],
        gender: data?['gender'],
        size: data?['size'],
        activity: data?['activity'],
        age: data?['age'],
        buddies: data?['buddies']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (owner != null) "owner": owner,
      if (photo != null) "photo": photo,
      if (name != null) "name": name,
      if (gender != null) "gender": gender,
      if (size != null) "size": size,
      if (activity != null) "activity": activity,
      if (age != null) "age": age,
      if (buddies != null) "buddies": buddies
    };
  }
  // factory Dog.fromDocument(QueryDocumentSnapshot<Object?>? doc) {
  //   final data = doc?.data()! as Map<String, dynamic>;
  //   return Dog.fromJson(data);
  // }
}