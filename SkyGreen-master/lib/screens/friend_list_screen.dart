import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Friend {
  final String name;
  final String profession;
  final String avatarUrl;

  Friend(this.name, this.profession, this.avatarUrl);
}

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({Key? key}) : super(key: key);

  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Friend> friends = []; // Replace with your actual list of friends
  List<Friend> filteredFriends = [];

  @override
  void initState() {
    super.initState();
    // Initialize your friends list here, for example:
    friends = List.generate(
      20,
      (index) => Friend(
          'Friend ${index + 1}', 'Flutter Developer', 'assets/images/pfp.jpg'),
    );
    filteredFriends = friends;
  }

  void _searchFriend(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredFriends = friends;
      });
    } else {
      setState(() {
        filteredFriends = friends
            .where((friend) =>
                friend.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _messageFriend(Friend friend) {
    // Implement messaging logic
    print('Messaging ${friend.name}');
  }

  void _callFriend(Friend friend) {
    // Implement calling logic
    print('Calling ${friend.name}');
  }

  void _deleteFriend(Friend friend) {
    // Implement delete logic
    setState(() {
      friends.remove(friend);
      filteredFriends.remove(friend);
    });
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
            LineAwesomeIcons.angle_left,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Friend List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.green,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(LineAwesomeIcons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.green[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: _searchFriend,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) {
                final friend = filteredFriends[index];
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(friend.avatarUrl),
                    ),
                    title: Text(
                      friend.name,
                      style: TextStyle(color: Colors.green),
                    ),
                    subtitle: Text(
                      friend.profession,
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.sms, color: Colors.green),
                          onPressed: () => _messageFriend(friend),
                        ),
                        IconButton(
                          icon: Icon(Icons.phone, color: Colors.green),
                          onPressed: () => _callFriend(friend),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteFriend(friend),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
