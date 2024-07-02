import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sky_green/screens/create_new_password_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  VerificationScreen({required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> codeControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  bool showError = false;

  bool get allFieldsFilled =>
      codeControllers.every((controller) => controller.text.isNotEmpty);

  void verifyRecoveryCode(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:9090/user/verifyRecoveryCode';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'recoveryCode':
            codeControllers.map((controller) => controller.text).join(),
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNewPasswordScreen(email: widget.email),
        ),
      );
    } else {
      setState(() {
        showError = true;
      });
      // Handle error, show a snackbar, or any other user feedback
      print('Error verifying recovery code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Verification",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the recovery code sent to ${widget.email}',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: 50,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 50,
                      child: TextField(
                        controller: codeControllers[index],
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                        focusNode: focusNodes[index],
                        onChanged: (value) {
                          if (value.length == 1 && index < 3) {
                            FocusScope.of(context)
                                .requestFocus(focusNodes[index + 1]);
                          }
                          setState(() {
                            showError = false;
                          });
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          errorText: showError ? 'Incorrect code' : null,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (allFieldsFilled)
                ElevatedButton(
                  onPressed: () => verifyRecoveryCode(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    minimumSize: Size(200, 60),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  child: Text('Verify Code',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
