import 'package:firebaseminer2/Helpers/GoogleSigningHelper.dart';
import 'package:firebaseminer2/Helpers/UserDetailMixin.dart';
import 'package:firebaseminer2/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
void updateThemeMode(bool darkMode) {
  Get.changeThemeMode(darkMode ? ThemeMode.dark : ThemeMode.light);
}
class _ProfilePageState extends State<ProfilePage> with UserDetailMixin{
  GoogleSigningHelper googleSignIn = GoogleSigningHelper();
  RxBool isDrakMode =false.obs;
  @override
  Widget build(BuildContext context) {
    print(user);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (user?.photoURL != null) ...[
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user?.photoURL ?? ''),
              ),
            ]else...[
              CircleAvatar(
                  radius: 60,
                  child: user?.photoURL == null
                      ? Text(
                    user!.email![0].toUpperCase() ?? '',
                    style: TextStyle(fontSize: 34),
                  ):SizedBox()
              )
            ],
            SizedBox(height: 16,),
            if (user != null) ...[
              Row(
                children: [
                  Text(
                    'Email :',
                    style: TextStyle(
                        fontSize: 14
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text(
                    user!.email!,
                    style: TextStyle(
                        fontSize: 14
                    ),  ),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Text(
                    'User id :',
                    style: TextStyle(
                        fontSize: 14
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text(
                    user! .uid,
                    style: TextStyle(
                        fontSize: 14
                    ),  ),
                ],
              ),
            ],
            if (googleSignIn.googleSignIn.currentUser != null) ...[
              Text('Email'),
              Text(googleSignIn.googleSignIn.currentUser?.email ?? ''),
              Text('Name'),
              Text(googleSignIn.googleSignIn.currentUser?.displayName ?? ''),
            ],
            SizedBox(height: 10,),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Theame',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
                Obx(() =>
                    IconButton(
                      onPressed: () {
                        isDrakMode.value=!isDrakMode.value;
                        updateThemeMode(isDrakMode.value);
                        GetStorage().write("appTheme", isDrakMode.value);
                      },
                      icon: isDrakMode.value
                          ? const Icon(Icons.mode_night)
                          : const Icon(Icons.light_mode_rounded),
                    ),
                )
              ],
            ),
            Divider(),
            SizedBox(height: 16,),
            ElevatedButton(

              clipBehavior: Clip.hardEdge,
              onPressed: () async {
                if (auth.currentUser != null) {
                  await auth.signOut();
                }
                if (googleSignIn.googleSignIn.currentUser != null) {
                     await googleSignIn.googleSignIn.signOut();
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
                await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
