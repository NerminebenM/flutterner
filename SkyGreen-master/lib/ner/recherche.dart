import 'package:flutter/material.dart';
import 'recherche_search_field.dart';
import 'dashboard.dart';
import 'profile_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class RechercheScreen extends StatefulWidget {
  final Profile user;

  RechercheScreen({required this.user});

  @override
  _RechercheScreenState createState() => _RechercheScreenState();
}

class _RechercheScreenState extends State<RechercheScreen> {
  String searchQuery = '';
  // List<Profile> profiles = [
  //   Profile(
  //     id: '1', // Remplacez par un identifiant unique
  //     name: "Nermine",
  //     lastName: "Nom de famille",
  //     info: "Informations supplémentaires",
  //     imageURL: "assets/images/nn.jpg",
  //     isAdmin: true,
  //   ),
  //   Profile(
  //     id: '2', // Remplacez par un identifiant unique
  //     name: "Achref",
  //     lastName: "Nom de famille",
  //     info: "Informations supplémentaires",
  //     imageURL: "assets/images/nn.jpg",
  //     isAdmin: false,
  //   ),
  //   Profile(
  //     id: '3', // Remplacez par un identifiant unique
  //     name: "Ala",
  //     lastName: "Nom de famille",
  //     info: "Informations supplémentaires",
  //     imageURL: "assets/images/nn.jpg",
  //     isAdmin: false,
  //   ),
  // ];
  List<Profile> profiles = [];
  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }

  Future<void> fetchProfiles() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/profiles'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        profiles = data.map((json) => Profile.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load profiles');
    }
  }
  @override
  Widget build(BuildContext context) {
    if (widget.user.isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Recherche de Profil'),
        ),
        body: Column(
          children: [
            RechercheSearchField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  if (profiles[index].name.toLowerCase().contains(searchQuery.toLowerCase())) {
                    return ProfileWidget(profile: profiles[index]);
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return DashboardScreen(user: widget.user);
    }
  }
}

class ProfileWidget extends StatelessWidget {
  final Profile profile;

  const ProfileWidget({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.pushNamed(
          context,
          '/profileDetail',
          arguments: ProfileDetailPage(profileId: profile.id),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(profile.imageURL),
        ),
        title: Text(profile.name),
        subtitle: Text(profile.info),
      ),
    );
  }
}
