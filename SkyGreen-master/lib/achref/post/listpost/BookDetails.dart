/*import 'dart:convert';

import 'package:sky_green/achref/post/listpost/UserPost.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostDetails extends StatefulWidget {
  // Modify the UserPost class based on your actual implementation
  final UserPost post;

  PostDetails({required this.post});

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final TextEditingController commentController = TextEditingController();
  List<String> comments = [];
  final String apiUrl =
      'http://10.0.2.2:3000'; // Replace with your API base URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display post details
            UserPost(
              id: widget.post.id,
              username: widget.post.username,
              postContent: widget.post.postContent,
              imageUrl: widget.post.imageUrl,
              // Add any other necessary parameters for UserPost
            ),
            // Display comments
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Comments:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // List of comments with increased height
            Container(
              height: 250, // Set your desired fixed height
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(comments[index]),
                  );
                },
              ),
            ),
            // Add a text input field for comments
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      addComment();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to fetch comments for a post
  Future<void> fetchComments() async {
    final postId = widget.post.id;

    final response = await http.get(Uri.parse('$apiUrl/api/comments/$postId'));

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON
      final List<dynamic> responseBody = json.decode(response.body);
      setState(() {
        comments =
            responseBody.map((comment) => comment['text'].toString()).toList();
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load comments');
    }
  }

  // Function to add a comment to the list and send it to the server
  Future<void> addComment() async {
    final String comment = commentController.text;
    final String? postId = widget.post.id;

    if (comment.isNotEmpty) {
      print('Adding comment: $comment');

      // Update the UI with the new comment
      setState(() {
        comments.add(comment);
        commentController.clear();
      });

      // Send the comment to the server
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/comments'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            if (postId != null) 'postId': postId,
            'text': comment,
          }),
        );

        if (response.statusCode == 201) {
          print('Comment added successfully');
        } else {
          print('Failed to add comment. Status code: ${response.statusCode}');
          // You might want to show a snackbar or handle the error in another way
        }
      } catch (error) {
        // Handle error
        print('Failed to add comment: $error');
        // You might want to show a snackbar or handle the error in another way
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch comments when the widget is first created
    fetchComments();
  }
*/