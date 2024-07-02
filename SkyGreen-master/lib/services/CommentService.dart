import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sky_green/util/globals.dart';

class CommentService {
  static Future createComment(Map<String, dynamic> commentData) async {
    final url = Uri.parse('$baseURL/comments');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(commentData),
      );

      if (response.statusCode == 201) {
        // Comment was successfully created
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        // Handle any errors here
        print('Failed to create comment. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create comment');
      }
    } catch (error) {
      // Handle exceptions or errors here
      print('Error creating comment: $error');
      throw Exception('Error creating comment: $error');
    }
  }

  static Future<List<Map<String, dynamic>>?> getAllComments(
      {String? eventID}) async {
    final url = Uri.parse('$baseURL/comments?eventID=$eventID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Map<String, dynamic>> comments =
            responseData.cast<Map<String, dynamic>>();
        return comments;
      } else {
        // Handle any errors here
        throw Exception('Failed to get comments');
      }
    } catch (error) {
      // Handle exceptions or errors here
      throw Exception('Error getting comments: $error');
    }
  }
}
