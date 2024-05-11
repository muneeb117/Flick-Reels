import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import '../../utils/colors.dart';
import 'message_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ChatScreen> {
  DialogFlowtter? dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title:
         Text(
        "Flicker Bot",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 23,
          color: Colors.black,
        ),
      ),
        // backgroundColor: AppColors.primaryBackground,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style:const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  isLoading
                      ? Container(
                    width: 20,
                    height: 20,
                    margin:const EdgeInsets.only(left: 15),
                    child:const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                    icon: Icon(Icons.send_rounded, color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        isLoading = true;
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter!.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      setState(() {
        isLoading = false;
        if (response.message != null) {
          addMessage(response.message!);
        } else {
          addMessage(Message(text: DialogText(text: ["..."])), false);  // Placeholder for no response
        }
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
