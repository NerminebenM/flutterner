import 'package:flutter/material.dart';

class buble_freinds extends StatelessWidget {
  final String text;
  final String img;
  buble_freinds({required this.text, required this.img});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
            ),
            child: ClipOval(
              child: Image.network(
                img, // Replace with your image URL
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(text)
        ],
      ),
    );
  }
}
