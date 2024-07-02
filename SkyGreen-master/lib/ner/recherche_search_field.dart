// import 'package:flutter/material.dart';
//
// class RechercheSearchField extends StatelessWidget {
//   final ValueChanged<String> onChanged;
//
//   const RechercheSearchField({
//     Key? key,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         hintText: "Rechercher un profil",
//         fillColor: Colors.white,
//         filled: true,
//         border: OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: const BorderRadius.all(Radius.circular(10)),
//         ),
//         suffixIcon: InkWell(
//           onTap: () {},
//           child: Container(
//             padding: EdgeInsets.all(10),
//             margin: EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//             ),
//             child: Icon(
//               Icons.search,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RechercheSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RechercheSearchField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  Future<void> _searchProfiles(String query) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/search?query=$query'),
    );

    if (response.statusCode == 200) {
      // Traitement des données de la réponse
      // Vous pouvez mettre à jour l'interface utilisateur en fonction des résultats ici
    } else {
      // Gestion des erreurs
      print('Erreur lors de la recherche : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        onChanged(value); // Appel de la fonction de rappel fournie par le parent
        _searchProfiles(value); // Appel de la fonction de recherche
      },
      decoration: InputDecoration(
        hintText: "Rechercher un profil",
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {
            // Vous pouvez également lancer la recherche ici si l'utilisateur appuie sur l'icône de recherche.
          },
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
