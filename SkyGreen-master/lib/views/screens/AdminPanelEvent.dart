import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sky_green/services/EventService.dart';
import 'package:sky_green/util/globals.dart';

class AdminPanelEvent extends StatefulWidget {
  @override
  _AdminPanelEventState createState() => _AdminPanelEventState();
}

class _AdminPanelEventState extends State<AdminPanelEvent> {
  List<Map<String, dynamic>> events = []; // Store event data

  @override
  void initState() {
    super.initState();
    // Fetch events when the widget initializes
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      // Fetch events using your EventService or API
      final response = await EventService.getAllEvents();
      final List<dynamic> eventList = json.decode(response);
      setState(() {
        events = eventList.cast<Map<String, dynamic>>();
      });
    } catch (error) {
      // Handle error (e.g., show an error message)
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await EventService.deleteEvent(eventId);
      // Re-fetch the events after deleting
      await fetchEvents();
    } catch (error) {
      // Handle error (e.g., show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Admin Panel - Events'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Set horizontal scroll direction
          child: DataTable(
            columnSpacing: 16.0, // Add this line to control column spacing
            columns: [
              DataColumn(label: Text('Event')),
              DataColumn(label: Text('Date & Time')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Actions')),
            ],
            rows: events.map((event) {
              return DataRow(
                cells: [
                  DataCell(Text(event['name'] ?? '')),
                  DataCell(Text(event['date'] ?? '')),
                  DataCell(Text(event['location'] ?? '')),
                  DataCell(Text(event['description'] ?? '')),
                  DataCell(
                    Container(
                      width: 80, // Adjust the image width as needed
                      child: Image.network(
                        '$baseURL/asma/${event['imagename']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Handle edit event action
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Delete Event'),
                                  content: Text(
                                      'Are you sure you want to delete this event?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteEvent(event[
                                            '_id']); // Call delete event method
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ));
  }
}
