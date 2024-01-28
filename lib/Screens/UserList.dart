import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseminer2/Helpers/UserDetailMixin.dart';
import 'package:firebaseminer2/Screens/ChatList.dart';
import 'package:firebaseminer2/Screens/ProfilePage.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> with UserDetailMixin {

  @override
  Widget build(BuildContext context) {
    print('------>>$usermodel');
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              icon: Icon(Icons.account_circle,size: 35,)
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('USERS').snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            var users = snapshot.data!.docs;
            List<Widget> UsertList = [];
            for(var user in users){
              var usertdata = user.data() as Map<String,dynamic>;
              if(auth.currentUser?.email != usertdata['email']) {
                UsertList.add(
                    Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatList(
                                        displayName:  usertdata['displayName'].toString(),
                                        userId: user.id,
                                        otherUserEmail: usertdata['Email'].toString(),// Pass the userId to the ChatList widget
                                      ),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(usertdata['displayName']?.toString() ?? ''),
                              subtitle: Text(usertdata['email']?.toString() ?? ''),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: usertdata['photoURL'] != null
                                    ? NetworkImage(usertdata['photoURL'])
                                    : null,
                                child: usertdata['photoURL'] == null
                                    ? Text(
                                  usertdata['Name']?[0].toUpperCase() ?? '',
                                  style: TextStyle(fontSize: 24),
                                )
                                    : null,
                              ),
                            )
                        ),
                        Divider()
                      ],
                    )
                );
              }
            }
            return ListView(children: UsertList);
          }
      ),
    );
  }
}
