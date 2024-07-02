import 'package:flutter/material.dart';

class msg extends StatelessWidget {
  final String name;
  final String image;
  final String desc;
  final String time;

  msg({
    required this.name,
    required this.image,
    required this.desc,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
            ),
            child: ClipOval(
              child: Image.network(
                'https://picsum.photos/40/40', // Replace with your image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name, // Replace with the name of the sender
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                desc, // Replace with the message description
              ),
            ],
          ),
          Spacer(), // This will push the time to the right
          Text(
            "10:30 AM", // Replace with the message time
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
