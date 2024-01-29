import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseminer2/Helpers/UserModel.dart';
import 'package:get/get.dart';

mixin class UserDetailMixin{
   FirebaseAuth auth = FirebaseAuth.instance;
   User? user = FirebaseAuth.instance.currentUser;
   UserModel? usermodel;
   RxString EmailString=''.obs;
}