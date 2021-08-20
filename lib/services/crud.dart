import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news/helper/constants.dart';
import 'package:news/models/user.dart';
import 'package:news/services/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrudMethod with ChangeNotifier {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  User _user;
  UserServices _userServices = UserServices();
  UserModel _userModel;

  Future<void> addData(blogData) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await auth.signInWithCredential(credential).then((userCredentials) async {
      _user = userCredentials.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await FirebaseFirestore.instance
          .collection("posts")
          .add(blogData)
          .catchError((e) {
        print(e);
      });
      if (!await _userServices.doesUserExist(_user.uid)) {
        _userServices.createUser(
            id: _user.uid, name: _user.displayName, photo: _user.photoURL);
        await initializeUserModel();
      } else {
        initializeUserModel();
      }
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("posts").get();
  }

  Future<bool> initializeUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _userId = preferences.getString('id');
    _userModel = await _userServices.getUserById(_userId);
    notifyListeners();
    if (_userModel == null) {
      return false;
    } else {
      return true;
    }
  }
}
