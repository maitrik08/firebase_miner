import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseminer2/Helpers/UserDetailMixin.dart';
import 'package:firebaseminer2/Helpers/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class EmailSignInabstract{
 Future LogIn({required String email,required String password});
 Future SignUp({required String email,required String password});
 Future LogOut();
}
class EmailSignInHelper extends EmailSignInabstract with UserDetailMixin{
  @override
  Future LogOut() async{
    if (auth.currentUser != null) {
      await auth.signOut();
      usermodel =await  UserModel(displayName:null, email: null, photoUrl: null, uid:null);
    }
    await Fluttertoast.showToast(
        msg: "Logout successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Future LogIn({required String email,required String password}) async{
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      user = await auth.currentUser;

      usermodel = await UserModel(displayName: auth.currentUser!.displayName!, email: auth.currentUser!.email!, photoUrl: auth.currentUser!.photoURL!, uid: auth.currentUser!.uid);
      return null;
    } on FirebaseAuthException catch (e) {
      return Fluttertoast.showToast(
          msg: "${e.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  @override
  Future<String?> SignUp({required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successful signup, set the usermodel
      user = auth.currentUser;
      if (user != null) {
        usermodel = UserModel(
            displayName: user!.displayName ?? "",
            email: user!.email ?? "",
            photoUrl: user!.photoURL ?? "",
            uid: user!.uid
        );
      }

      // Return a success message
      return 'success';
    } on FirebaseAuthException catch (e) {
      // Throw an exception with the error message
      throw Exception(e.message);
    }
  }


}