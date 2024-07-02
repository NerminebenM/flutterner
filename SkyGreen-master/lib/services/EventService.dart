import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sky_green/util/globals.dart';

class EventService {
  static Future<String> getAllEvents() async {
    final response = await http.get(Uri.parse('$baseURL/Events/events'));
    if (response.statusCode == 200) {
      print("ok");
      return response.body;
    } else {
      print("no no");
      throw Exception('Failed to fetch events');
    }
  }

  static Future<void> createEvent(
      Map<String, dynamic> eventFormData, File? image) async {
    final apiUrl =
        '$baseURL/Events'; // Replace with the actual API endpoint for creating events

    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    for (var entry in eventFormData.entries) {
      request.fields[entry.key] = entry.value.toString();
    }

    if (image != null) {
      final imageFile = await http.MultipartFile.fromPath(
        'imagename',
        image.path,
      );
      request.files.add(imageFile);
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        // Event created successfully, you can handle the response here
        print('Event created successfully');
      } else {
        // Event creation failed, handle the error
        print('Event creation failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending the request: $e');
    }
  }

  static Future<String> getEventById(String eventId) async {
    final apiUrl =
        '$baseURL/Events/events/$eventId'; // Replace with the actual API endpoint for fetching an event by ID
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      throw Exception('Event not found');
    } else {
      throw Exception('Failed to fetch the event');
    }
  }

  static Future<void> deleteEvent(String eventId) async {
    final apiUrl =
        '$baseURL/Events/$eventId'; // Replace with the actual API endpoint for deleting an event by ID

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 204) {
        // Event deleted successfully, you can handle the response here
        print('Event deleted successfully');
      } else {
        // Event deletion failed, handle the error
        print('Event deletion failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending the request: $e');
    }
  }

  static Future<void> participateUserInEvent(
      String eventId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/Events/events/participate/$eventId'),
        body: jsonEncode({'userId': userId}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print("User successfully participated in the event");
      } else if (response.statusCode == 404) {
        print("Event or user not found");
      } else {
        print("Failed to participate in the event");
      }
    } catch (error) {
      print("Error participating in the event: $error");
    }
  }
}
