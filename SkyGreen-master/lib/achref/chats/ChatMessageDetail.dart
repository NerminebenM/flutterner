import 'package:flutter/material.dart';

class ChatMessageDetail extends StatefulWidget {
  final String name;
  final List<Message> messages;

  ChatMessageDetail({required this.name, required this.messages});

  @override
  _ChatMessageDetailState createState() => _ChatMessageDetailState();
}

class _ChatMessageDetailState extends State<ChatMessageDetail> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      final newMessage = Message(id: 1, text: messageText);
      setState(() {
        widget.messages.add(newMessage);
      });
      _messageController.clear();

      // Scroll to the end of the list
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 116, 223, 89),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.name, style: TextStyle(color: Colors.white)),
            Icon(Icons.call, color: Colors.white),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/a.jpg', // Replace with the path to your image asset
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.messages.length,
                  itemBuilder: (context, index) {
                    final message = widget.messages[index];
                    final isUser = message.id == 1;

                    return MessageWidget(
                      message: message.text,
                      isUser: isUser,
                    );
                  },
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 236, 236, 236),
                ),
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Message {
  final int id;
  final String text;

  Message({required this.id, required this.text});
}

class MessageWidget extends StatelessWidget {
  final String message;
  final bool isUser;

  MessageWidget({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isUser ? Colors.green : Color.fromARGB(255, 236, 236, 236),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(message),
      ),
    );
  }
}
