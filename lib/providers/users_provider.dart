import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app2/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  UserModel? getUserModel() {
    return userModel;
  }

  Future<UserModel?> fetchUserInfo() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return null;
    }
    var uid = user.uid;
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final userData = userDoc.data()!;
      userModel = UserModel(
        userId: userData['userId'],
        userName: userData['userName'],
        userImage: userData['userImage'],
        userEmail: userData['userEmail'],
        userCart: userData.containsKey('userCart')?userData['userCart']:[],
        userWish: userData.containsKey('userWish')?userData['userWish']:[],
        createdAt: userData['createdAt'],
      );
      return userModel;
    } on FirebaseException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }
}
