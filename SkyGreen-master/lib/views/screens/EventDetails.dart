// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_green/services/CommentService.dart';
import 'package:sky_green/services/EventService.dart';
import 'package:sky_green/util/globals.dart';

class EventDetails extends StatefulWidget {
  final String eventId;

  EventDetails({required this.eventId});

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails>
    with AutomaticKeepAliveClientMixin<EventDetails> {
  Map<String, dynamic> eventData = {};
  bool participated = false;
  TextEditingController commentController = TextEditingController();
  List<String> comments = []; // List to store comments
  @override
  bool get wantKeepAlive => true; // Preserve the widget's state

  String? id;
  String? username;

  @override
  void initState() {
    super.initState();
    // Fetch event details when the widget initializes
    fetchEventDetails();
    fetchComments();
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
    String? usernamel = prefs.getString('username');
    String? email = prefs.getString('email');
    String? image = prefs.getString('image');
    String? idl = prefs.getString('id');
    setState(() {
      id = idl;
      username = usernamel;
    });
    print('Token: $token');
    print('Username: $usernamel');
    print('Email: $email');
    print('Image: $image');
    print('Id: $idl');
  }

  Future<void> fetchEventDetails() async {
    try {
      final response = await EventService.getEventById(widget.eventId);
      final Map<String, dynamic> data = json.decode(response);
      await printSharedPreferences();
      setState(() {
        eventData = data;

        // Check if the current user's ID is in the participants list
        final userId = id!; // Replace with the actual user's ID
        final participants = eventData['participants'];
        if (participants != null && participants is List) {
          final participantIds = participants.map((participant) {
            return participant['_id'];
          }).toList();
          if (participantIds.contains(userId)) {
            // User has already participated
            participated = true;
          }
        }
      });
    } catch (error) {
      // Handle error (e.g., show an error message)
    }
  }

  Future<void> _deleteEvent() async {
    try {
      await EventService.deleteEvent(widget.eventId);
      Navigator.of(context).pop();
      Navigator.of(context)
          .pop(); // Navigate back to the homepage after deletion
    } catch (error) {
      // Handle error (e.g., show an error message)
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteEvent(); // Call the delete event method
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _participateInEvent() async {
    try {
      await EventService.participateUserInEvent(widget.eventId, id!);
      // Set participated to true after successful participation
      setState(() {
        participated = true;
      });
      // Show a success pop-up
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Participation Successful'),
            content: Text('You have successfully participated in the event.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Handle error and show an error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error Participating'),
            content: Text(
                'There was an error participating in the event. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Fetch comments for the event
  Future<void> fetchComments() async {
    try {
      final eventID = widget.eventId;
      List<Map<String, dynamic>>? commentsData =
          await CommentService.getAllComments(eventID: eventID);

      setState(() {
        comments = commentsData!
            .map((comment) => comment['content'] as String)
            .toList();
      });
    } catch (error) {
      // Handle error (e.g., show an error message)
    }
  }

  void addComment(String comment) {
    final commentData = {
      'event': widget.eventId, // Assuming 'event' is the key for event ID
      'content': comment, // Assuming 'text' is the key for the comment text
    };

    setState(() {
      comments.add(comment);
      commentController.clear();
      // Send the comment to the server using CommentService.createComment
      CommentService.createComment(commentData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 300, // Adjust the height as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(150),
                  bottomRight: Radius.circular(150),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      '$baseURL/asma/${eventData['imagename']}' ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventData['name'] ?? 'Event Name',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            eventData['date'] ?? 'Event Date & Time',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            eventData['description'] ?? 'Event Description',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            eventData['location'] ?? 'Event Location',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          // Comment section in a separate box with its own scroll view
                          Container(
                              height:
                                  200, // Adjust the initial height as needed
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: CircleAvatar(// Profile Icon
                                        // You can set a background color or load an image here
                                        ),
                                    title: Text(
                                        username!), // Replace 'User Name' with the actual user name
                                    subtitle: Text(
                                        comments[index]), // Comment Content
                                  );
                                },
                              )),
                          SizedBox(height: 10),
                          // Comment input field
                          TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Add a comment...',
                            ),
                          ),
                          SizedBox(height: 10),
                          // Submit Comment Button
                          ElevatedButton.icon(
                            onPressed: () {
                              // Add the comment to the list
                              if (commentController.text.isNotEmpty) {
                                addComment(commentController.text);
                              }
                            },
                            icon: Icon(Icons.send),
                            label: Text('Comment'),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: participated
                    ? () {
                        // User has already participated
                      }
                    : () {
                        // User has not participated, so allow participation
                        _participateInEvent();
                      },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (participated) {
                      // Change the button color when participated
                      return Colors.grey;
                    }
                    return Colors.blue; // Default color when not participated
                  }),
                ),
                child: Text(participated ? 'Participated' : 'Participate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
