import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news/helper/constants.dart';
import 'package:news/models/user.dart';

class UserServices {
  String collection = "users";

  void createUser({String id, String name, String photo}) {
    firebaseFirestore
        .collection(collection)
        .doc(id)
        .set({"name": name, "id": id, "photo": photo});
  }

  Future<UserModel> getUserById(String id) =>
      firebaseFirestore.collection(collection).doc(id).get().then((document) {
        return UserModel.fromSnapshot(document);
      });

  Future<bool> doesUserExist(String id) async => firebaseFirestore
      .collection(collection)
      .doc(id)
      .get()
      .then((value) => value.exists);

  Future<List<UserModel>> getAllUser() async =>
      firebaseFirestore.collection(collection).get().then((result) {
        List<UserModel> users = [];
        for (DocumentSnapshot user in result.docs) {
          users.add(UserModel.fromSnapshot(user));
        }
        return users;
      });
}
