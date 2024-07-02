import 'package:flutter/material.dart';
import 'package:sky_green/achref/chats/ChatMessageDetail2.dart';
import 'package:sky_green/achref/chats/buble_freinds.dart';
import 'package:sky_green/achref/chats/models/friendsMsg.dart';
import 'package:sky_green/achref/chats/msg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class chat extends StatefulWidget {
  @override
  _chatState createState() => _chatState();
}

class _chatState extends State<chat> {
  final List<Map<String, dynamic>> friends = [
    {
      "name": "achref",
      "image": "https://picsum.photos/40/40",
    },
    {
      "name": "ala",
      "image": "https://picsum.photos/40/40",
    },
    {
      "name": "nermin",
      "image": "https://picsum.photos/40/40",
    },
    {
      "name": "asma",
      "image": "https://picsum.photos/40/40",
    },
    {
      "name": "achref",
      "image": "https://picsum.photos/40/40",
    },
    {
      "name": "achref",
      "image": "https://picsum.photos/40/40",
    },
    // ... add more friends
  ];

  List<friendsMsg> messages = [
    friendsMsg(
        idf: 2, name: "ala", chat: "l 3alaa id 2", image: "x", time: "10:05"),
    friendsMsg(
        idf: 3,
        name: "nermine",
        chat: "l 3alaa id 2",
        image: "x",
        time: "10:05"),
    friendsMsg(
        idf: 4, name: "asma", chat: "l 3alaa id 2", image: "x", time: "10:05"),
    friendsMsg(
        idf: 5,
        name: "oussema",
        chat: "l 3alaa id 2",
        image: "x",
        time: "10:05"),
    friendsMsg(
        idf: 6, name: "ahmed", chat: "l 3alaa id 2", image: "x", time: "10:05"),
    friendsMsg(
        idf: 2,
        name: "khalil",
        chat: "l 3alaa id 2",
        image: "x",
        time: "10:05"),
    friendsMsg(
        idf: 2,
        name: "marwen",
        chat: "l 3alaa id 2",
        image: "x",
        time: "10:05"),

    // ... add more messages
  ];

  Future<void> updateMessagesFromAPI(int userId) async {
    final apiUrl = 'http://10.0.2.2:3000/lastMessages/$userId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> apiMessages =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        for (var apiMessage in apiMessages) {
          updateChatByIdf(apiMessage['receiverId'], apiMessage['text']);
        }

        // Optionally, print the updated messages list
        messages.forEach((message) {
          print(
              "ID: ${message.idf}, Name: ${message.name}, Chat: ${message.chat}");
        });

        // Update the UI with the new messages
        setState(() {
          filteredMessages = List.from(messages);
        });
      } else {
        print("Failed to fetch messages from API: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  void updateChatByIdf(int idf, String newChat) {
    var foundMessages = messages.where((message) => message.idf == idf);

    if (foundMessages.isNotEmpty) {
      foundMessages.forEach((message) {
        message.chat = newChat;
      });
    } else {
      throw Exception("Message with ID $idf not found");
    }
  }

  TextEditingController searchController = TextEditingController();
  List<friendsMsg> filteredMessages = [];

  @override
  void initState() {
    super.initState();
    updateMessagesFromAPI(1);
    filteredMessages = List.from(messages);
  }

  void filterSearchResults(String query) {
    List<friendsMsg> searchResults = [];
    if (query.isNotEmpty) {
      searchResults = messages.where((msg) {
        return msg.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      searchResults = List.from(messages);
    }

    setState(() {
      filteredMessages = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set the background color to green
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Chats', style: TextStyle(color: Colors.black)),
            Icon(Icons.add_comment_outlined),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors
                    .lightGreen, // Set the search bar background color to light green
              ),
              child: TextField(
                controller: searchController,
                onChanged: filterSearchResults,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: friends.length + 1,
              itemBuilder: (context, index) {
                if (index == friends.length) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Avoir plus',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  );
                } else {
                  final item = friends[index];
                  return buble_freinds(text: item["name"], img: item["image"]);
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                final item2 = filteredMessages[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          updateMessagesFromAPI(1);
                          return ChatMessageDetail2(
                            myId: 1,
                            friendId: item2.idf,
                            friendName: item2.name,
                          );
                        },
                      ),
                    );
                  },
                  child: msg(
                    name: item2.name,
                    image: item2.image,
                    desc: item2.chat,
                    time: item2.time,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
