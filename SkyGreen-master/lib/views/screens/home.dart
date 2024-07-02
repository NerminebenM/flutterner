import 'package:flutter/material.dart';
import 'package:sky_green/services/EventService.dart';
import 'package:sky_green/util/globals.dart';
import 'package:sky_green/views/screens/EventDetails.dart';
import 'package:sky_green/views/screens/eventaddpage.dart';
import 'package:sky_green/views/widgets/post_item.dart';

// Import your EventService
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> dynamicPosts = []; // Store event data from API

  // Function to fetch event data from the API
  Future<void> fetchEventPosts() async {
    try {
      final response = await EventService.getAllEvents();
      final List<dynamic> parsedData = json.decode(response);

      setState(() {
        dynamicPosts = parsedData.map((event) {
          return {
            'id': event['_id'],
            'img':
                '$baseURL/asma/${event['imagename']}', // Replace 'baseurl' with your base URL
            'name': event['name'],
            'dp': 'assets/images/EH_Logo_stacked_RGB.jpg', // Static image
            'time': event['date']
                .toString(), // Convert date to a string or format it as needed
            'eventData': event, // Store the event data for navigation
          };
        }).toList();
      });
    } catch (error) {
      // Handle error (e.g., show an error message)
    }
  }

  Future<void> _refreshData() async {
    // Fetch event data when the user triggers a refresh
    await fetchEventPosts();
  }

  @override
  void initState() {
    super.initState();
    fetchEventPosts(); // Fetch event data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                // You can use this selectedCategory value to filter your event list.
                // Call a function to fetch and display events based on the selected category.
              });
            },
            itemBuilder: (BuildContext context) {
              return ['Local Events', 'International Events']
                  .map((String category) {
                return PopupMenuItem<String>(
                  value: category,
                  child: Text(
                    category,
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 5, 84, 10), // Change the text color to blue
                    ),
                  ),
                );
              }).toList();
            },
            color: Colors.grey,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: dynamicPosts.length,
          itemBuilder: (BuildContext context, int index) {
            Map post = dynamicPosts[index];
            return Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // Handle post item tap
                  },
                  child: PostItem(
                    img: post['img'],
                    name: post['name'],
                    dp: post['dp'],
                    time: post['time'],
                    eventId: post['id'],
                  ),
                ),
                SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 16, 94, 6),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventPage(),
            ),
          );
        },
      ),
    );
  }
}
