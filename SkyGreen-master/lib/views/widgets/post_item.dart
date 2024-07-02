import 'package:flutter/material.dart';
import 'package:sky_green/views/screens/EventDetails.dart';

class PostItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String img;
  final String eventId; // Add an event ID property

  PostItem({
    super.key,
    required this.dp,
    required this.name,
    required this.time,
    required this.img,
    required this.eventId, // Initialize the event ID
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          final eventId = widget.eventId;
          print(' event with ID: $eventId');
          // Navigate to EventDetails with the event ID
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetails(eventId: widget.eventId),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "${widget.dp}",
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              title: Text(
                "${widget.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "${widget.time}",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
            ),
            Image.network(
              "${widget.img}",
              height: 170,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
