import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseminer2/Helpers/UserDetailMixin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatList extends StatefulWidget {
  ChatList({Key? key, required this.displayName,required this.userId,required this.otherUserEmail});

  final String displayName;
  final String userId;
  final String otherUserEmail;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with UserDetailMixin{
  TextEditingController messageController = TextEditingController();
  final db = FirebaseFirestore.instance;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.displayName),

      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getMessages(user!.email??'', widget.otherUserEmail),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List<DocumentSnapshot> messages = snapshot.data!.docs;
                  print(messages);
                  return ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, index) =>
                        buildItem(index, messages[index]),
                    itemCount: messages.length,
                  );
                }
              },
            ),
          ),
          buildInputArea(),
        ],
      ),
    );
  }
  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }
  Widget buildItem(int index, DocumentSnapshot document) {
    Timestamp? timestamp = document.get("timestamp") as Timestamp?;
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      String formattedTime = DateFormat("h:mm a").format(dateTime);

      return Align(
        alignment: document.get("senderId") == user!.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.indigo.shade500,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: document.get("senderId") == user!.uid
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '${document.get("message")}',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  formattedTime,
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        alignment: document.get("senderId") == user!.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Text(
          'waiting',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
  }

  Widget buildInputArea() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              sendMessage(user!.uid, widget.userId, messageController.text,user!.email??'',widget.otherUserEmail);
              messageController.clear();
              scrollToBottom();
            },
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(
      String senderId,
      String receiverId,
      String message,
      String senderEmail,
      String receiverEmail,
      ) async {
    if (message.isNotEmpty) {
      String chatRoomId = getChatRoomId(senderEmail, receiverEmail);
      DocumentSnapshot chatDoc = await db.collection("CHAT_ROOMS").doc(chatRoomId).get();
      if (!chatDoc.exists) {
        await db.collection("CHAT_ROOMS")
            .doc(chatRoomId)
            .collection("MESSAGES")
            .add({
          'senderId': senderId,
          'receiverId': receiverId,
          'message': message,
          'senderEmial': senderEmail,
          'reciverEmail': receiverEmail,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }
  }



  String getChatRoomId(String userEmail, String otherUserEmail) {
    List<String> emails = [userEmail, otherUserEmail];
    emails.sort();
    return '${emails[0]}_${emails[1]}';
  }


  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    String chatRoomId = getChatRoomId(userId, otherUserId);
    return db
        .collection("CHAT_ROOMS")
        .doc(chatRoomId)
        .collection('MESSAGES')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
