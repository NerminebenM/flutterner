// import 'package:flutter/material.dart';
//
// class FeedScreen extends StatefulWidget {
//   @override
//   _FeedScreenState createState() => _FeedScreenState();
// }
//
// class _FeedScreenState extends State<FeedScreen> {
//   @override
//   Widget build(BuildContext context) {
//     // Récupérer les données des publications
//     List<Post> posts = fetchPosts();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fil d\'actualité'),
//       ),
//       body: _buildFeedContent(posts),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // À implémenter : Ajoutez la logique pour créer une nouvelle publication.
//           // Vous pouvez afficher un dialogue ou naviguer vers une nouvelle page pour créer la publication.
//           // Une fois que la nouvelle publication est créée, ajoutez-la à la liste "posts" et rafraîchissez l'écran.
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   Widget _buildFeedContent(List<Post> posts) {
//     return ListView.builder(
//       itemCount: posts.length,
//       itemBuilder: (context, index) {
//         Post post = posts[index];
//         return Card(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ListTile(
//                 title: Text(
//                   post.author,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text(
//                   post.timestamp,
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//               ListTile(
//                 title: Text(post.title),
//                 subtitle: Text(post.body),
//               ),
//               ButtonBar(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.comment),
//                     onPressed: () {
//                       // À implémenter : Ajoutez la logique pour commenter une publication.
//                     },
//                   ),
//                   if (isAdmin()) // Afficher les actions d'administration uniquement si l'utilisateur est un administrateur
//                     IconButton(
//                       icon: Icon(Icons.block),
//                       onPressed: () {
//                         // À implémenter : Ajoutez la logique pour bloquer la publication.
//                       },
//                     ),
//                   if (isAdmin())
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         // À implémenter : Ajoutez la logique pour supprimer la publication.
//                       },
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   bool isAdmin() {
//     // À implémenter : Vérifiez si l'utilisateur actuel est un administrateur.
//     return true; // Par exemple, renvoie true si l'utilisateur est administrateur.
//   }
// }
//
// // Modèle de données pour une publication
// class Post {
//   final String author;
//   final String timestamp;
//   final String title;
//   final String body;
//
//   Post({
//     required this.author,
//     required this.timestamp,
//     required this.title,
//     required this.body,
//   });
// }
//
// // Une fonction factice pour récupérer des publications
// List<Post> fetchPosts() {
//   return [
//     Post(
//       author: 'Nermine Ben Massoued',
//       timestamp: '2 heures ago',
//       title: 'photo',
//       body: '',
//     ),
//     Post(
//       author: 'ALa',
//       timestamp: '4 heures ago',
//       title: 'photo',
//       body: '',
//     ),
//     Post(
//       author: 'Achref',
//       timestamp: '1 day ago',
//       title: 'photo',
//       body: '',
//     ),
//     Post(
//       author: 'Nermine_ben',
//       timestamp: '1 jour ago',
//       title: 'Challenge',
//       body: '++++++++++',
//     ),
//     Post(
//       author: 'Nermine',
//       timestamp: '1 semaine ago',
//       title: 'Event',
//       body: 'go to zoo',
//     ),
//   ];
// }
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late List<Post> posts=[];
  bool isAdminUser = true;
  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        posts = responseData.map((data) => Post.fromJson(data)).toList();
      });
    } else {
      throw Exception('Erreur lors de la récupération des publications');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fil d\'actualité'),
      ),
      body: _buildFeedContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFeedContent() {
    if (posts == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        Post post = posts[index];
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  post.author,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  post.timestamp,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
              ),
              ButtonBar(
                children: [
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      // À implémenter : Ajoutez la logique pour commenter une publication.
                    },
                  ),
                  if (isAdmin()) // Afficher les actions d'administration uniquement si l'utilisateur est un administrateur
                    IconButton(
                      icon: Icon(Icons.block),
                      onPressed: () {
                        // À implémenter : Ajoutez la logique pour bloquer la publication.
                      },
                    ),
                  if (isAdmin())
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // À implémenter : Ajoutez la logique pour supprimer la publication.
                      },
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool isAdmin() {
    // À implémenter : Vérifiez si l'utilisateur actuel est un administrateur.
    return isAdminUser; // Par exemple, renvoie la valeur de la variable isAdminUser.
  }
}

// Modèle de données pour une publication
class Post {
  final String author;
  final String timestamp;
  final String title;
  final String body;

  Post({
    required this.author,
    required this.timestamp,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      author: json['author'],
      timestamp: json['timestamp'],
      title: json['title'],
      body: json['body'],
    );
  }
}
