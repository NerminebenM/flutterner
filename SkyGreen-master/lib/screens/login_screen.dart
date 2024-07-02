import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  GlobalKey<State> _progressHUDKey = GlobalKey<State>();

  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        body: ProgressHUD(
          key: _progressHUDKey,
          child: Form(
            key: loginFormKey,
            child: _loginUI(context),
          ),
          inAsyncCall: isAPIcallProcess,
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
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
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/longLogo.png",
                width: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              bottom: 30,
              top: 50,
            ),
            child: Text(
              "Login",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          _inputFieldWidget(
            context,
            "username",
            "username or email",
            (value) {
              if (value?.isEmpty ?? true) {
                return "username is required";
              }
              return null;
            },
            (value) {
              username = value;
            },
            prefixIcon: Icon(Icons.person, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _inputFieldWidget(
              context,
              "password",
              "Password",
              (value) {
                if (value?.isEmpty ?? true) {
                  return "the password is required";
                }
                return null;
              },
              (value) {
                password = value;
              },
              obscureText: hidePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.white.withOpacity(0.7),
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 25, top: 10),
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'forget password ?',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/forget');
                            }),
                    ]),
              ),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (loginFormKey.currentState!.validate()) {
                  loginFormKey.currentState!.save();
                  setState(() {
                    isAPIcallProcess = true;
                  });
                  await signIn(context, username!, password!);
                  setState(() {
                    isAPIcallProcess = false;
                  });
                }
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
              child: Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text("OR",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                )),
          ),
          SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google Icon
              GestureDetector(
                onTap: () {
                  print('google');
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/google.png',
                    width: 50, // Adjust the width and height as needed
                    height: 50,
                  ),
                ),
              ),

              // Facebook Icon
              GestureDetector(
                onTap: () {
                  print('facebook');
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/facebook.png',
                    width: 50, // Adjust the width and height as needed
                    height: 50,
                  ),
                ),
              ),

              // FaceID Icon
              GestureDetector(
                onTap: () async {
                  await authenticateWithBiometrics();
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/faceId.png',
                    width: 50, // Adjust the width and height as needed
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 25, top: 10),
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'dont have an account yet ? ',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      TextSpan(
                          text: 'sign up',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/register');
                            }),
                    ]),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _inputFieldWidget(
    BuildContext context,
    String label,
    String hint,
    FormFieldValidator<String?> validator,
    FormFieldSetter<String?> onSaved, {
    bool obscureText = false,
    Icon? prefixIcon,
    IconButton? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: obscureText,
        validator: validator,
        onSaved: onSaved,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Future<void> authenticateWithBiometrics() async {
    final localAuth = LocalAuthentication();

    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        bool didAuthenticate = await localAuth.authenticate(
          localizedReason:
              'Authenticate to access your account', // Reason for authentication.
        );

        if (didAuthenticate) {
          // User successfully authenticated using biometrics.
          // You can now proceed to sign in or navigate to another screen.
          await signIn(context, username!, password!);
        }
      }
    } catch (e) {
      print('Biometric authentication error: $e');
    }
  }
}

//  api consomation
Future<void> signIn(
    BuildContext context, String emailOrUsername, String password) async {
  final url = Uri.parse('http://10.0.2.2:9090/user/signin');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'emailOrUsername': emailOrUsername,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
// for android localhost
      String imageUrl = data['image']
          .replaceAll(RegExp('http://localhost'), 'http://10.0.2.2');
      await prefs.setString('token', data['token']);
      await prefs.setString('username', data['username']);
      await prefs.setString('id', data['id']);
      await prefs.setString('image', imageUrl);
      await prefs.setString('email', data['email']);
      // Navigate to the next screen or show a success message

      await printSharedPreferences();

      // Here you could navigate to the next screen or show a success message
      // Navigator.of(context).pushReplacementNamed('/home')
      // Navigate to the next screen here after saving
      Navigator.pushNamed(context, '/listpost'); // Use the correct route name
    } else {
      final data = json.decode(response.body);
      // Handle the error, show an alert dialog or a snackbar with data['Message']
    }
  } catch (e) {
    // Handle the exception, show an alert dialog or a snackbar with the error
    print('Error signing in: $e');
  }
}

Future<void> printSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();

  // // To print all keys and values
  // print('Shared preferences keys and values:');
  // prefs.getKeys().forEach((key) {
  //   print('$key: ${prefs.get(key)}');
  // });

  // Or to print a specific value:
  String? token = prefs.getString('token');
  String? username = prefs.getString('username');
  String? email = prefs.getString('email');
  String? image = prefs.getString('image');
  String? id = prefs.getString('id');

  print('Token: $token');
  print('Username: $username');
  print('Email: $email');
  print('Image: $image');
  print('Id: $id');
}
