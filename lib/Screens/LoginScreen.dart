import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseminer2/Helpers/EmailSignInHelper.dart';
import 'package:firebaseminer2/Helpers/GoogleSigningHelper.dart';
import 'package:firebaseminer2/Helpers/UserDetailMixin.dart';
import 'package:firebaseminer2/Screens/Anonymous.dart';
import 'package:firebaseminer2/Screens/UserList.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with UserDetailMixin {
  UserCredential? userCredential;
  final db = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController displayName = TextEditingController();
  EmailSignInHelper EmailService = EmailSignInHelper();
  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.network('https://i.pinimg.com/474x/f2/b2/a6/f2b2a62e80ab3840aea71fb79783c1d5.jpg',height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 90),
                  Text(
                    'Welcome',
                    style: TextStyle(
                        fontFamily: 'Pattaya',
                        fontSize: 35
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: displayName,
                    decoration: InputDecoration(
                        labelText: 'User Name',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(7))
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(7))
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(7))
                    ),
                  ),
                  SizedBox(height: 16.0),
                  InkWell(
                    onTap: () async{
                      await EmailService.LogIn(email: _emailController.text, password: _passwordController.text);
                     // if(user != null){
                        await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserList()));
                     // }
                      print('login ${auth.currentUser!.email}');
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.indigo.shade400,
                          borderRadius: BorderRadius.circular(7)
                      ),
                      child: Center(
                        child: Text('Login',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      SizedBox(width: 4),
                      InkWell(
                        onTap: () async{
                          EmailService.SignUp(email: _emailController.text, password: _passwordController.text);
                          Map<String,dynamic> User = await{
                            "Email" : auth.currentUser!.email,
                            "displayName" : displayName.text,
                            "Profile_Image": auth.currentUser?.photoURL
                          };
                          db.collection('USERS').add(User).then((DocumentReference doc) =>
                              print('DocumentSnapshot added with ID: ${doc.id}'));

                          if(user != null){
                            await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserList()));
                          }
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async{
                      GoogleSigningHelper googleSigning = GoogleSigningHelper();
                      await googleSigning.LogIn();
                      print(usermodel!.email);
                      print(googleSigning.user!.email);
                      if(googleSigning.googleSignIn != null){
                        await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserList()));
                      }

                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [BoxShadow(blurRadius: 5,color: Colors.grey.shade600,offset: Offset(3, 3),spreadRadius: 3)]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSO0u4dr5oCgDbhigc4GH5o4PMEZGwVaHabRg&usqp=CAU',height: 30,width: 30,fit: BoxFit.fill,),
                            ),
                            Text('Sign in with google')
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text('Or'),
                  InkWell(
                    onTap: () async{
                      userCredential = await auth.signInAnonymously();
                      user = await userCredential!.user;
                      await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Anonymous()));
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.symmetric(horizontal: 70,vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [BoxShadow(blurRadius: 5,color: Colors.grey.shade600,offset: Offset(3, 3),spreadRadius: 3)]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.account_circle,size: 50),
                            Text('Sign in as guest')
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

