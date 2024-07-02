import 'package:flutter/material.dart';
import 'package:sky_green/ner/dashboard.dart';
import 'package:sky_green/ner/feed_screen.dart';
import 'profile_detail.dart';
import 'recherche.dart';
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Mon Application Flutter',
//       theme: ThemeData(
//         primaryColor: Colors.green,
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.green,
//           iconTheme: IconThemeData(color: Colors.green),
//         ),
//         scaffoldBackgroundColor: Colors.green,
//       ),
//       home: const MyHomePage(title: 'Mon Application Flutter'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   bool _showDashboard = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green, // Couleur d'arrière-plan de l'écran
//       appBar: AppBar(
//         title: Image.asset(
//           'assets/images/logo.png',
//           width: 100, // Largeur souhaitée
//           height: 30, // Hauteur souhaitée
//         ),
//       ),
//       // main.dart
//
//       // main.dart
//
//       body: _showDashboard
//           ? DashboardScreen(user: Profile("nermine", "nermine", "aa", 'assets/images/nn.jpg', true))
//           : FeedScreen(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _showDashboard ? 0 : 1,
//         onTap: (int index) {
//           setState(() {
//             _showDashboard = index == 0;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.dashboard,
//               color: _showDashboard ? Colors.green : Colors.grey,
//             ),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//               color: !_showDashboard ? Colors.green : Colors.grey,
//             ),
//             label: 'Home',
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
// }
// main.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Profile adminUser = Profile(
      id: 'admin_id',
      name: "nermine",
      lastName: "nermine",
      info: "aa",
      imageURL: 'assets/images/nn.jpg',
      isAdmin: true,
    );

    Profile normalUser = Profile(
      id: 'normal_id',
      name: "nermine",
      lastName: "nermine",
      info: "aa",
      imageURL: 'assets/images/nn.jpg',
      isAdmin: false,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon Application Flutter',
      theme: ThemeData(
        primaryColor: Colors.green,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.green),
        ),
        scaffoldBackgroundColor: Colors.green,
      ),
      home: MyHomePage(
        title: 'Mon Application Flutter',
        user: adminUser,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.user});

  final String title;
  final Profile user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _showDashboard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          width: 100,
          height: 30,
        ),
      ),
      body: _showDashboard
          ? DashboardScreen(user: widget.user)
          : FeedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _showDashboard ? 0 : 1,
        onTap: (int index) {
          setState(() {
            _showDashboard = index == 0;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
              color: _showDashboard ? Colors.green : Colors.grey,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: !_showDashboard ? Colors.green : Colors.grey,
            ),
            label: 'Home',
          ),
        ],
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
}
