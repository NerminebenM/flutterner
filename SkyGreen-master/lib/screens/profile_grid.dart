import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileGrid extends StatefulWidget {
  const ProfileGrid({Key? key}) : super(key: key);

  @override
  _ProfileGridState createState() => _ProfileGridState();
}

class _ProfileGridState extends State<ProfileGrid> {
  late String _username;
  late String _profession;
  late String _avatarUrl;
  late int _postsCount;
  late int _freindsCount;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    setState(() {
      _username = 'Nermine';
      _profession = 'Flutter Developer';
      _avatarUrl =
          'assets/images/pfp.jpg'; // Replace with your actual avatar asset
      _postsCount = 100;
      _freindsCount = 1500;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          _buildProfileHeaderAndStats(),
          _buildActionButtons(),
          Expanded(
            child: SingleChildScrollView(
              child: _buildPhotoGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderAndStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(_avatarUrl),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_username,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Text(_profession,
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              _buildStatItem('Posts', _postsCount),
              _buildStatItem('Books', _freindsCount),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Text('$count',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildButton('Edit Profile', () {
            Navigator.pushNamed(context, "/updateProfile");
          }),
          _buildButton('Books', () {
            // Define action for Promotions button
          }),
          _buildButton('Contacts', () {
            Navigator.pushNamed(context, "/friends");
          }),
        ],
      ),
    );
  }

  Widget _buildButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title, style: TextStyle(color: Colors.blue)),
      style: ElevatedButton.styleFrom(
        //primary: Colors.white,
       // onPrimary: Colors.green,
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Add padding at the bottom
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 2,
        ),
        itemCount: 12, // The number of items in the grid
        itemBuilder: (context, index) {
          return Image.asset(
            'assets/images/pfp.jpg', // Use your actual profile picture asset
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
