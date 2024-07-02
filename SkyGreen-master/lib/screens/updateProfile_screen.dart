import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? capturedImage;
  String? savedImagePath;

  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  GlobalKey<State> _progressHUDKey = GlobalKey<State>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadSavedImage(); // Load the saved image path from SharedPreferences when the widget is initialized
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            LineAwesomeIcons.angle_left,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Edit profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.green,
      body: ProgressHUD(
        key: _progressHUDKey,
        child: Form(
          key: globalFormKey,
          child: _RegisterUI(context),
        ),
        inAsyncCall: isAPIcallProcess,
        opacity: 0.3,
      ),
    );
  }

  Widget _RegisterUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                        )
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: capturedImage != null
                        ? ClipOval(
                            child: Image.file(
                              capturedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : savedImagePath != null
                            ? ClipOval(
                                child: Image.network(
                                  savedImagePath!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/images/pfp.jpg"),
                                    colorFilter: ColorFilter.mode(
                                      Colors.green.withOpacity(0.3),
                                      BlendMode.dstATop,
                                    ),
                                  ),
                                ),
                              ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Colors.white),
                          color: Colors.green),
                      child: InkWell(
                        onTap: () {
                          showBottomSheet();
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: TextField(
              controller: passwordController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  color: Colors.white,
                  icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                updateProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 50, vertical: 20), // adjusted padding
                minimumSize: Size(200, 60), // minimum width and height
                textStyle: TextStyle(fontSize: 20), // font size of button text
              ),
              child:
                  Text('Update', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
              child: RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      children: <TextSpan>[
                    TextSpan(
                      text: 'Joined on  ',
                      style: TextStyle(
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                    TextSpan(
                      text: ' 6 november 2023',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ])),
            ),
          ),
        ],
      ),
    );
  }

  void showBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext cont) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  print('Camera');
                  _takePicture();
                },
                child: Text('Use Camera'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  print('Upload files');
                  _pickImage();
                },
                child: Text('Upload from gallery'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(cont).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          );
        });
  }

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        capturedImage = File(pickedImage.path);
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        capturedImage = File(pickedImage.path);
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('image');
    setState(() {
      savedImagePath = imagePath;
    });
  }

  //apiiiiiii
  Future<void> updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Retrieve the stored token

    if (token == null) {
      print('No token found!');
      return;
    }

    final api =
        'http://localhost:9090/user/updateProfile'; // Update with your actual server IP if not running on the same device
    final uri = Uri.parse(api);
    final request = http.MultipartRequest('PUT', uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Ensure your token is correctly included
      });

    // Add other user fields to the request
    request.fields['username'] = usernameController.text;
    request.fields['email'] = emailController.text;
    if (passwordController.text.isNotEmpty) {
      request.fields['password'] = passwordController.text;
    }

    // If there is a captured image, include it in the request
    if (capturedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        capturedImage!.path,
      ));
    }

    // If you want to include the savedImagePath when there is no new captured image, uncomment below
    // else if (savedImagePath != null && savedImagePath!.isNotEmpty) {
    //   request.fields['imageUrl'] = savedImagePath!;
    // }

    try {
      setState(() {
        isAPIcallProcess = true;
      });

      // Send the PUT request
      final streamedResponse = await request.send();

      // Get the response from the server
      final response = await http.Response.fromStream(streamedResponse);

      setState(() {
        isAPIcallProcess = false;
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Update the UI or display a message after successfully updating the profile
        print('Profile updated: $responseData');
      } else {
        // Handle error response
        print('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isAPIcallProcess = false;
      });
      print('Error updating profile: $e');
    }
  }
}
