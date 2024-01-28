import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseminer2/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: 'AIzaSyBVkO4WuyRcSYAAUVaBejxiChNnSjs70L8', appId: '1:361691122408:android:df8e732adaa95c3257575d', messagingSenderId: '', projectId: 'fir-miner2-e2054')
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      color: Colors.blue,

      theme:ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: GetStorage().read("appTheme") == true ?ThemeMode.dark:ThemeMode.light,
      home: Splashscreen(),
    );
  }
}

