import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController captionController = TextEditingController();
  String? imagePath;

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _submitPost() async {
    if (imagePath == null || captionController.text.isEmpty) {
      // Handle validation or show an error message
      return;
    }

    final uri = Uri.parse('http://10.0.2.2:3000/api/posts');
    var request = http.MultipartRequest('POST', uri);
    request.fields['username'] = 'JohnDoe';
    request.fields['postContent'] = captionController.text;

    request.files
        .add(await http.MultipartFile.fromPath('imageUrl', imagePath!));

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        // Post was successful
        print("Successful post");

        // Navigate back to the previous screen
        Navigator.pop(context);

        // Add any additional logic or navigation you need
      } else {
        // Handle the error, e.g., show an error message
        print("Error during post. Status code: ${response.statusCode}");
        print(await response.stream.bytesToString());
      }
    } catch (error) {
      // Handle the error, e.g., show an error message
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.camera),
                            title: Text('Take a Photo'),
                            onTap: () {
                              _getImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.image),
                            title: Text('Choose from Gallery'),
                            onTap: () {
                              _getImage(ImageSource.gallery);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 200,
                color: Colors.grey[200],
                child: imagePath != null
                    ? Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.grey,
                      ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: captionController,
              decoration: InputDecoration(
                labelText: 'Caption',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
