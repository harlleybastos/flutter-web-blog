import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "id";
  static const NAME = "name";
  static const PHOTO = "photo";

  String _id;
  String _name;
  String _photo;

  String get name => _name;
  String get photo => _photo;
  String get id => _id;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> fireStoreInfo = snapshot.data();
    _name = snapshot[NAME];
    _photo = snapshot[PHOTO];
    _id = snapshot[ID];
  }
}
