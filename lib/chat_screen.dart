import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:project/Messages.dart';
import 'package:project/ProfileEdit.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _setupDialogFlowtter();
  }

  void _setupDialogFlowtter() async {
    try {
      dialogFlowtter = await DialogFlowtter.fromFile(
        path: 'assets/dialog_flow_auth.json',
      );
    } catch (e) {
      print('Error initializing DialogFlowtter: $e');
    }
  }

  void _sendMessage(String text) async {
    if (text.isEmpty) return;

    // เพิ่มข้อความของผู้ใช้ในแชท
    _addMessage(Message(text: DialogText(text: [text])), true);
    _controller.clear();

    try {
      // ดึงข้อมูลผู้ใช้ปัจจุบัน
      User? user = _auth.currentUser;

      // เพิ่มข้อมูลผู้ใช้ใน Dialogflow request
      var context = {
        'userId': user?.uid,
        'userEmail': user?.email,
      };

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
        queryParams: QueryParameters(
          payload: context,
        ),
      );

      if (response.message == null) return;

      // ประมวลผลการตอบกลับ
      if (response.queryResult?.fulfillmentMessages != null) {
        for (Message message in response.queryResult!.fulfillmentMessages!) {
          _addMessage(message);
        }
      }
    } catch (e) {
      print('Error sending message to Dialogflow: $e');
    }
  }

  void _addMessage(Message message, [bool isUserMessage = false]) {
    setState(() {
      messages.add({
        'message': message,
        'isUserMessage': isUserMessage,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MessagesScreen(
              messages: messages,
              onChipSelected: (String selected) {
                _sendMessage(selected);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: Color(0xFF3C1A80),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }
}
