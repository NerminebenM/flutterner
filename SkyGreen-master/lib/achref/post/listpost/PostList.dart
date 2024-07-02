import 'package:sky_green/CustomBottomNavigationBar.dart';
import 'package:sky_green/achref/post/listpost/PostDetails.dart';
import 'package:sky_green/achref/post/listpost/UserPost.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  List<UserPost> posts = [];
  String urldata = "http://10.0.2.2:3000";

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  int _currentIndex = 0;

  Future<void> fetchPosts() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/api/posts'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          posts = responseData
              .map((post) => UserPost(
                    id: post['_id'],
                    username: post['username'],
                    postContent: post['postContent'],
                    imageUrl: urldata + "/uploads/" + post['imageUrl'],
                    // Add other properties as needed
                  ))
              .toList();
        });
      } else {
        // Throw an exception for error status codes
        throw Exception('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions, e.g., network issues
      print('Error during fetchPosts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', textAlign: TextAlign.center),
        automaticallyImplyLeading: false, // Disables the back button
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to another screen when the UserPost is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetails(
                    post: posts[index],

                    // You can pass any additional data to the details screen
                  ),
                ),
              );
            },
            child: UserPost(
              id: posts[index].id,
              username: posts[index].username,
              postContent: posts[index].postContent,
              imageUrl: posts[index].imageUrl,
              // Add any other necessary parameters for UserPost
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _currentIndex = index;
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/chat');
              break;
            case 1:
              Navigator.pushNamed(context, '/listpost');
              break;
            case 2:
              Navigator.pushNamed(context, '/addpost');
              break;

            case 3:
              Navigator.pushNamed(context, '/adminEvent');
              break;
            case 4:
              Navigator.pushNamed(context, '/events');
              break;
            case 5:
              Navigator.pushNamed(context, '/profile');
              break;
            default:
          }
        },
      ),
    );
  }
}
