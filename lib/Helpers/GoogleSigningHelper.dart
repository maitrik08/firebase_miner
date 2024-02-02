import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseminer2/Helpers/UserDetailMixin.dart';
import 'package:firebaseminer2/Helpers/UserModel.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleSigningabstract{
  Future LogIn();
  Future LogOut();
}


class GoogleSigningHelper extends GoogleSigningabstract with UserDetailMixin{
  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];
  GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  Future LogIn() async{
    googleSignIn = GoogleSignIn(scopes: scopes);
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        Map<String, dynamic> userData = {
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
        };
        usermodel ??= UserModel(displayName: user.displayName!, email: user.email!, photoUrl: user.photoURL!, uid: user.uid);
        print('///////${usermodel!.email}');
        await FirebaseFirestore.instance.collection('USERS').doc(user.uid).set(userData);
      }
    }
  }

  @override
  Future LogOut() async{
    await googleSignIn.signOut();
    usermodel = UserModel(displayName:null, email: null, photoUrl: null, uid:null);
  }
}