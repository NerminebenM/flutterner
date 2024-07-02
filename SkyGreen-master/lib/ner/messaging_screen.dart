// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// class MessagingScreen extends StatefulWidget {
//   @override
//   _MessagingScreenState createState() => _MessagingScreenState();
// }
//
// class _MessagingScreenState extends State<MessagingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     List<Conversation> conversations = fetchConversations();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Messagerie'),
//       ),
//       body: _buildMessagingContent(conversations),
//     );
//   }
//
//   Widget _buildMessagingContent(List<Conversation> conversations) {
//     return ListView.builder(
//       itemCount: conversations.length,
//       itemBuilder: (context, index) {
//         Conversation conversation = conversations[index];
//         return Card(
//           elevation: 3,
//           margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(conversation.user.profilePicture),
//             ),
//             title: Text(conversation.user.name, style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text(conversation.lastMessage),
//             trailing: PopupMenuButton<String>(
//               onSelected: (String choice) {
//                 if (choice == 'Bloquer') {
//
//                 } else if (choice == 'Supprimer') {
//
//                 } else if (choice == 'Bannir') {
//
//                 }
//               },
//               itemBuilder: (BuildContext context) {
//                 return ['Bloquer', 'Supprimer', 'Bannir'].map((String choice) {
//                   return PopupMenuItem<String>(
//                       value: choice,
//                       child: Row(
//                           children: [
//                           if (choice == 'Bloquer') Icon(Icons.block, color: Colors.red),
//                   if (choice == 'Supprimer') Icon(Icons.delete, color: Colors.blue),
//                   if (choice == 'Bannir') Icon(Icons.report, color: Colors.orange),
//                   SizedBox(width: 8),
//                   Text(choice, style: TextStyle(color: Colors.black),
//                   ),
//                   ],
//                   ),
//
//                   );
//                 }).toList();
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class Conversation {
//   final User user;
//   final String lastMessage;
//
//   Conversation({required this.user, required this.lastMessage});
// }
//
// class User {
//   final String name;
//   final String profilePicture;
//
//   User({required this.name, required this.profilePicture});
// }
//
// List<Conversation> fetchConversations() {
//   return [
//     Conversation(
//       user: User(name: 'achref', profilePicture: 'https://example.com/profile1.jpg'),
//       lastMessage: 'Salut, comment ça va ?',
//     ),
//     Conversation(
//       user: User(name: 'ala', profilePicture: 'https://example.com/profile2.jpg'),
//       lastMessage: 'Bonjour !',
//     ),
//
//   ];
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessagingScreen extends StatefulWidget {
  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  List<Conversation> conversations = [];

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/conversations'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        conversations = data.map((json) => Conversation.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load conversations');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messagerie'),
      ),
      body: _buildMessagingContent(),
    );
  }

  Widget _buildMessagingContent() {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        Conversation conversation = conversations[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(conversation.user.profilePicture),
            ),
            title: Text(conversation.user.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(conversation.lastMessage),
            trailing: PopupMenuButton<String>(
              onSelected: (String choice) {
                if (choice == 'Bloquer') {
                  // Ajoutez votre logique de blocage ici
                } else if (choice == 'Supprimer') {
                  // Ajoutez votre logique de suppression ici
                } else if (choice == 'Bannir') {
                  // Ajoutez votre logique de bannissement ici
                }
              },
              itemBuilder: (BuildContext context) {
                return ['Bloquer', 'Supprimer', 'Bannir'].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Row(
                      children: [
                        if (choice == 'Bloquer') Icon(Icons.block, color: Colors.red),
                        if (choice == 'Supprimer') Icon(Icons.delete, color: Colors.blue),
                        if (choice == 'Bannir') Icon(Icons.report, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(choice, style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),
        );
      },
    );
  }
}

class Conversation {
  final User user;
  final String lastMessage;

  Conversation({required this.user, required this.lastMessage});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      user: User(
        name: json['user']['name'],
        profilePicture: json['user']['profilePicture'],
      ),
      lastMessage: json['lastMessage'],
    );
  }
}

class User {
  final String name;
  final String profilePicture;

  User({required this.name, required this.profilePicture});
}
