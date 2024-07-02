import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sky_green/services/EventService.dart';
import 'dart:io';
import 'package:sky_green/util/globals.dart';
import 'package:sky_green/views/screens/home.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  File? _image; // Variable to store the selected image
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // Function to pick an image from the gallery
  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
    });
  }

  Future<void> createEvent() async {
    final eventFormData = {
      'name': eventNameController.text,
      'date': dateTimeController.text,
      'description': descriptionController.text,
      'location': locationController.text,
    };

    try {
      await EventService.createEvent(eventFormData, _image);

      // Event created successfully
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Event created successfully!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>
                            Home()), // Navigate to the Home page
                    (Route<dynamic> route) =>
                        false, // Clear the navigation stack
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Event creation failed
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Error creating the event: $e"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    eventNameController.dispose();
    dateTimeController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Event"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: eventNameController,
              decoration: InputDecoration(
                labelText: "Event Name",
                icon: Icon(Icons.event),
              ),
            ),
            TextField(
              controller: dateTimeController,
              decoration: InputDecoration(
                labelText: "Date and Time",
                icon: Icon(Icons.calendar_today),
              ),
              readOnly: true, // Make the input field read-only
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  // Format the selected date and set it in the controller
                  final formattedDate =
                      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                  dateTimeController.text = formattedDate;
                }
              },
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                icon: Icon(Icons.description),
              ),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "Location",
                icon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _pickImage(ImageSource.gallery);
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: _image != null
                        ? Image.file(
                            _image!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              "Tap to select an image",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: createEvent,
              child: Text("Create Event"),
              style: ButtonStyle (backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}
