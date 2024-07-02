import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Add bottom padding to center icons vertically
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white, // Set the background color to white
        items: <BottomNavigationBarItem>[
          _buildNavItem(Icons.chat, currentIndex == 0),
          _buildNavItem(Icons.home, currentIndex == 1),
          _buildNavItem(Icons.add, currentIndex == 2),
          _buildNavItem(Icons.event_busy, currentIndex == 3),
          _buildNavItem(Icons.event_note_rounded, currentIndex == 4),
          _buildNavItem(Icons.person, currentIndex == 5),
          _buildNavItem(Icons.dashboard, currentIndex == 6),
        ],
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.green, // Set the selected icon color to green
        unselectedItemColor:
            Colors.grey[500], // Set the unselected icon color to grey
        iconSize: 28, // Adjust icon size
        selectedFontSize:
            0, // Set selectedFontSize to 0 to hide the label for the selected item
        unselectedFontSize:
            0, // Set unselectedFontSize to 0 to hide the label for unselected items
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, bool isSelected) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: isSelected
            ? Colors.green
            : Colors.grey[500], // Set icon color based on selection
      ),
      label: '', // Set label to an empty string to hide labels
    );
  }
}
