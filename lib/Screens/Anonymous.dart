import 'package:firebaseminer2/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';
class Anonymous extends StatelessWidget {
  const Anonymous({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'You must have ccount to access'
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('LogIn')
          )
        ],
      ),
    );
  }
}
