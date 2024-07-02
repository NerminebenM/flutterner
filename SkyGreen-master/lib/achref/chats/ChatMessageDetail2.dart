import 'package:sky_green/achref/call/CallPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatMessageDetail2 extends StatefulWidget {
  final int myId;
  final int friendId;
  final String friendName;

  ChatMessageDetail2(
      {required this.myId, required this.friendId, required this.friendName});

  @override
  _ChatMessageDetail2State createState() => _ChatMessageDetail2State();
}

class _ChatMessageDetail2State extends State<ChatMessageDetail2> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  late final WebSocketChannel channel;

  @override
  void initState() {
    super.initState();

    // Create a function to fetch chat messages from your API
    void fetchChatMessages() async {
      final myId = widget.myId;
      final friendId = widget.friendId;
      print(friendId);
      final url = Uri.parse(
          'http://10.0.2.2:3000/api/messages?myId=$myId&friendId=$friendId');
      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final List<Map<String, dynamic>> chatMessages =
              List<Map<String, dynamic>>.from(data);

          setState(() {
            messages = chatMessages;
          });
        } else {
          // Handle the error, e.g., show an error message.
        }
      } catch (e) {
        // Handle any exceptions here, e.g., show an error message.
      }
    }

    // Call the function to fetch chat messages when the page loads
    fetchChatMessages();

    channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:3000'));
    channel.sink.add(json
        .encode({"senderId": widget.myId, "receiverId": -1, "text": "2zi"}));

    channel.stream.listen((data) {
      final messageData = json.decode(data);
      final newMessage = {
        'senderId': messageData['senderId'],
        'text': messageData['text'],
      };
      setState(() {
        messages.add(newMessage);
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    // Close the WebSocket channel when the widget is disposed
    channel.sink.close();
    super.dispose();
  }

  void _sendMessage() {
    final messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      final senderId = widget.myId;
      final receiverId = widget.friendId;
      final text = messageText;

      final messageData = {
        "senderId": senderId,
        "receiverId": receiverId,
        "text": text,
      };

      channel.sink.add(json.encode(messageData));

      final newMessage = {
        'senderId': senderId,
        'text': text,
      };
      setState(() {
        messages.add(newMessage);
      });

      _messageController.clear();

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
            Text(widget.friendName, style: TextStyle(color: Colors.white)),
            GestureDetector(
              // Wrap the icon with GestureDetector
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CallPage(callID: "aaaaa")), // Push CallPage
                );
              },
              child: Icon(Icons.call, color: Colors.white),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/a.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUser = message['senderId'] == widget.myId;

                    return MessageWidget(
                      message: message['text'].toString(),
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
