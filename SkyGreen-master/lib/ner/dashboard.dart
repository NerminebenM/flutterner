import 'package:flutter/material.dart';
import 'feed_screen.dart';
import 'messaging_screen.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';
import 'recherche.dart';
import 'profile_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// class DashboardScreen extends StatefulWidget {
//   final Profile user;
//
//   DashboardScreen({required this.user});
//
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   int _currentIndex = 0;
//
//   late List<Widget> _screens;
//
//   @override
//   void initState() {
//     super.initState();
//     _screens = [
//       FeedScreen(),
//       RechercheScreen(user: widget.user),
//       MessagingScreen(),
//       SettingsScreen(),
//       StatisticsScreen(),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }
//
//   BottomNavigationBar _buildBottomNavigationBar() {
//     return BottomNavigationBar(
//       currentIndex: _currentIndex,
//       onTap: (int index) {
//         setState(() {
//           _currentIndex = index;
//         });
//       },
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.home,
//             color: _currentIndex == 0 ? Colors.green : Colors.grey,
//           ),
//           label: 'Feed',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.search,
//             color: _currentIndex == 1 ? Colors.green : Colors.grey,
//           ),
//           label: 'Search',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.message,
//             color: _currentIndex == 2 ? Colors.green : Colors.grey,
//           ),
//           label: 'Messaging',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.settings,
//             color: _currentIndex == 3 ? Colors.green : Colors.grey,
//           ),
//           label: 'Settings',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.bar_chart,
//             color: _currentIndex == 4 ? Colors.green : Colors.grey,
//           ),
//           label: 'Statistics',
//         ),
//       ],
//     );
//   }
// }
// dashboard.dart

/*class DashboardScreen extends StatefulWidget {
  final Profile user;

  DashboardScreen({required this.user});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      FeedScreen(),
      if (widget.user.isAdmin) RechercheScreen(user: widget.user),
      MessagingScreen(),
      SettingsScreen(),
      StatisticsScreen(userId: '123'),
    ];
  }
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://10.0.2.2:3000/users'));

    if (response.statusCode == 200) {
      // La réponse du serveur est OK
      final List<dynamic> data = json.decode(response.body);
      // Faites quelque chose avec les données récupérées, par exemple, mettez à jour l'état de votre widget.
      setState(() {
        // ... mettre à jour votre état avec les données
      });
    } else {
      // Si la requête n'est pas OK, vous pouvez gérer les erreurs ici.
      print('Erreur lors de la récupération des données : ${response.statusCode}');
    }
  }

  @override
//
  Widget build(BuildContext context) {
    if (widget.user.isAdmin) {
      // Afficher le tableau de bord
      return Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
    } else {
      // Rediriger vers le FeedScreen si l'utilisateur n'est pas un administrateur
      return FeedScreen();
    }
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: _currentIndex == 0 ? Colors.green : Colors.grey,
          ),
          label: 'Feed',
        ),
        if (widget.user.isAdmin)
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _currentIndex == 1 ? Colors.green : Colors.grey,
            ),
            label: 'Search',
          ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.message,
            color: _currentIndex == 2 ? Colors.green : Colors.grey,
          ),
          label: 'Messaging',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: _currentIndex == 3 ? Colors.green : Colors.grey,
          ),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bar_chart,
            color: _currentIndex == 4 ? Colors.green : Colors.grey,
          ),
          label: 'Statistics',
        ),
      ],
    );
  }
}*/
