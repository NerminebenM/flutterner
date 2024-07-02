import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileDetailPage extends StatefulWidget {
  final String profileId;

  ProfileDetailPage({required this.profileId});

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  late Future<Profile> profile;

  @override
  void initState() {
    super.initState();
    profile = fetchProfile();
  }

  Future<Profile> fetchProfile() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/profiles/${widget.profileId}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Profile.fromJson(data);
    } else {
      throw Exception('Erreur lors de la récupération du profil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Profile>(
          future: profile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Chargement...');
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else {
              return Text(snapshot.data!.name);
            }
          },
        ),
      ),
      body: FutureBuilder<Profile>(
        future: profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!.imageURL),
                    radius: 50,
                  ),
                  Text(snapshot.data!.name),
                  Text(snapshot.data!.lastName),
                  Text(snapshot.data!.info),
                  Text('Admin: ${snapshot.data!.isAdmin ? 'Oui' : 'Non'}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class Profile {
  final String id;
  final String name;
  final String lastName;
  final String info;
  final String imageURL;
  final bool isAdmin;

  Profile({
    required this.id,
    required this.name,
    required this.lastName,
    required this.info,
    required this.imageURL,
    required this.isAdmin,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      info: json['info'],
      imageURL: json['imageURL'],
      isAdmin: json['isAdmin'],
    );
  }
}
