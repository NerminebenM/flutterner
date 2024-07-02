// import 'package:flutter/material.dart';
//
// class SettingsScreen extends StatefulWidget {
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Paramètres'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: _buildSettingsContent(),
//     );
//   }
//
//   Widget _buildSettingsContent() {
//     return ListView(
//       children: [
//         _buildSettingItem(
//           title: 'Notifications',
//           icon: Icons.notifications,
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
//           },
//         ),
//         _buildSettingItem(
//           title: 'Confidentialité',
//           icon: Icons.lock,
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacySettingsScreen()));
//           },
//         ),
//         _buildSettingItem(
//           title: 'Compte utilisateur',
//           icon: Icons.person,
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => UserAccountScreen()));
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSettingItem({
//     required String title,
//     required IconData icon,
//     required void Function() onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       onTap: onTap,
//     );
//   }
// }
//
// class NotificationsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gérer les notifications'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Liste des comptes d\'utilisateurs'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Ajoutez ici la logique pour modifier les notifications du profil pour l'utilisateur sélectionné
//                 // Vous pouvez afficher une boîte de dialogue pour personnaliser les options de notification.
//               },
//               child: Text('Modifier les notifications du profil'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Ajoutez ici la logique pour modifier les notifications d'ajout de publication pour l'utilisateur sélectionné
//                 // Vous pouvez afficher une boîte de dialogue pour personnaliser les options de notification.
//               },
//               child: Text('Modifier les notifications d\'ajout de publication'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class PrivacySettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Paramètres de confidentialité'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Paramètres de confidentialité (pour l\'administrateur)'),
//             SizedBox(height: 20),
//             Text('Gérer les paramètres de confidentialité ici'),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class UserAccountScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gérer le compte utilisateur'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Gérer le compte utilisateur (pour l\'administrateur)'),
//             SizedBox(height: 20),
//             Text('Modifier les détails du compte'),
//             ElevatedButton(
//               onPressed: () {
//                 // Ajoutez ici la logique pour modifier les détails du compte
//               },
//               child: Text('Modifier le compte'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: SettingsScreen(),
//   ));
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Remplacez cette URL par l'URL de votre serveur
  final String baseUrl = 'http://10.0.2.2:3000/api/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildSettingsContent(),
    );
  }

  Widget _buildSettingsContent() {
    return ListView(
      children: [
        _buildSettingItem(
          title: 'Notifications',
          icon: Icons.notifications,
          onTap: () {
            _handleNotifications();
          },
        ),
        _buildSettingItem(
          title: 'Confidentialité',
          icon: Icons.lock,
          onTap: () {
            _handlePrivacy();
          },
        ),
        _buildSettingItem(
          title: 'Compte utilisateur',
          icon: Icons.person,
          onTap: () {
            _handleUserAccount();
          },
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required String title,
    required IconData icon,
    required void Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  // Fonction pour gérer les notifications
  Future<void> _handleNotifications() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json', // Indique que le corps de la requête est du JSON
        },
        body: jsonEncode({
          'enablePostNotifications': true, // Exemple de paramètre
          'enableMessageNotifications': false, // Exemple de paramètre
          // Ajoutez ici d'autres paramètres nécessaires pour la gestion des notifications
        }),
      );

      if (response.statusCode == 200) {
        // Succès
        print('Notifications mises à jour avec succès');
      } else {
        // Erreur
        print('Erreur lors de la mise à jour des notifications');
      }
    } catch (error) {
      // Erreur réseau
      print('Erreur réseau: $error');
    }
  }


  // Fonction pour gérer la confidentialité
  Future<void> _handlePrivacy() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/privacy'),
        headers: {
          'Content-Type': 'application/json', // Indique que le corps de la requête est du JSON
        },
        body: jsonEncode({
          'enablePrivateProfile': true, // Exemple de paramètre
          'enableTwoFactorAuth': false, // Exemple de paramètre
          // Ajoutez ici d'autres paramètres nécessaires pour la gestion de la confidentialité
        }),
      );

      if (response.statusCode == 200) {
        // Succès
        print('Paramètres de confidentialité mis à jour avec succès');
      } else {
        // Erreur
        print('Erreur lors de la mise à jour des paramètres de confidentialité');
      }
    } catch (error) {
      // Erreur réseau
      print('Erreur réseau: $error');
    }
  }

  // Fonction pour gérer le compte utilisateur
  Future<void> _handleUserAccount() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user-account'),
        headers: {
          'Content-Type': 'application/json', // Indique que le corps de la requête est du JSON
        },
        body: jsonEncode({
          'username': 'nouveauNom', // Exemple de paramètre
          'email': 'nouveauEmail@example.com', // Exemple de paramètre
          'password': 'nouveauMotDePasse', // Exemple de paramètre
          // Ajoutez ici d'autres paramètres nécessaires pour la gestion du compte utilisateur
        }),
      );

      if (response.statusCode == 200) {
        // Succès
        print('Détails du compte utilisateur mis à jour avec succès');
      } else {
        // Erreur
        print('Erreur lors de la mise à jour des détails du compte utilisateur');
      }
    } catch (error) {
      // Erreur réseau
      print('Erreur réseau: $error');
    }
  }

}
