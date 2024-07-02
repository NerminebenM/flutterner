import 'package:flutter/material.dart';

class UserPost extends StatelessWidget {
  String? id;
  final String username;
  final String postContent;
  final String imageUrl; // You can use this for post images
  final Function()? onLikePressed;

  UserPost({
    required this.id,
    required this.username,
    required this.postContent,
    this.imageUrl = '',
    this.onLikePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  // You can replace the placeholder image with the user's profile image
                  backgroundImage: NetworkImage('https://picsum.photos/40/40'),
                ),
                SizedBox(width: 8),
                Text(
                  username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          if (imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              height: 200, // Adjust the height as needed
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(postContent),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: onLikePressed,
              ),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  // Implement comment functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
