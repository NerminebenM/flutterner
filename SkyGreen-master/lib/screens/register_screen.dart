import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:snippet_coder_utils/ProgressHUD.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? capturedImage;
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _RegisterUI(context),
          ),
          inAsyncCall: isAPIcallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _RegisterUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/longLogo.png",
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              bottom: 0,
            ),
            child: Text(
              "Register",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Center(
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
                signUpUser();
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
              child: Text('Register',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text("OR",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                )),
          ),
          // SizedBox(
          //   height: 3,
          // ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 25, top: 10),
              child: RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      children: <TextSpan>[
                    TextSpan(
                      text: 'you have already an account ? ',
                      style: TextStyle(
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                    TextSpan(
                        text: ' Sign in',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, "/login");
                          }),
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

  Future<void> signUpUser() async {
    final prefs = await SharedPreferences.getInstance();
    final requestUrl =
        'http://10.0.2.2:9090/user/signup'; // Replace with your API endpoint
    var uri = Uri.parse(requestUrl);

    // Prepare the form data
    var request = http.MultipartRequest('POST', uri)
      ..fields['username'] = usernameController.text
      ..fields['email'] = emailController.text
      ..fields['password'] = passwordController.text;

    // Attach the image file if it's selected
    if (capturedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // the 'image' key must match the key expected by your backend
          capturedImage!.path,
        ),
      );
    }

    // Send the request
    var streamedResponse = await request.send();

    // Listen for the response
    await streamedResponse.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> response = json.decode(value);
      if (streamedResponse.statusCode == 201) {
        // Save the token, username, image, and email
        String imageUrl = response['image']
            .replaceAll(RegExp('http://localhost'), 'http://10.0.2.2');
        await prefs.setString('token', response['token']);
        await prefs.setString('username', response['username']);
        await prefs.setString('image', imageUrl);
        await prefs.setString('email', response['email']);

        // Navigate to the profile screen
        Navigator.pushNamed(context, '/profile');
      } else {
        // Handle the error, you might want to show an alert to the user
        print('Error: ${response['message']}');
      }
    });
  }
}
