import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_green/CustomBottomNavigationBar.dart';

import 'UserPost.dart';

// Modèle de données pour un livre
class Book {
  final String id;
  final String title;
  final String author;
  final int year;
  bool available;
  final String imageUrl;
  final String summary;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.available,
    required this.imageUrl,
    required this.summary,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'author': author,
      'year': year,
      'available': available,
      'imageUrl': imageUrl,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Unknown Title',
      author: json['author'] ?? 'Unknown Author',
      year: json['year'] ?? 0,
      available: json['available'] ?? true,
      imageUrl: json['imageUrl'] ?? 'assets/images/default_image.png',
      summary: json['summary'] ?? 'Unknown summary',
    );
  }
}

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  List<Book> books = [];
  List<Book> wishlist = [];
  int _currentIndex = 0;
  bool isLoading = true;
  String errorMessage = '';
  TextEditingController _searchController = TextEditingController();
  String? userId;
  @override
  void initState() {
    super.initState();
    fetchBooks();
    fetchWishlist();
    getUserId();

  }
  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }
  Future<void> fetchBooks([String query = '']) async {
    try {
      final apiUrl = "http://10.0.2.2:9090/books?search=$query";
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['books'];
        setState(() {
          books = responseData.map((book) => Book.fromJson(book)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch books: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error during fetchBooks: $e';
      });
      print('Error during fetchBooks: $e');
    }
  }

  Future<void> reserveBook(String id) async {
    try {
      final apiUrl = "http://10.0.2.2:9090/books/reserve/$id";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Book reserved successfully');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Your reservation is successfully reserved.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

        setState(() {
          final book = books.firstWhere((book) => book.id == id);
          book.available = false;
          saveReservedBook(book);
        });
      } else if (response.statusCode == 400) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Not Available'),
              content: Text('This book is not available for reservation.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to reserve book: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during reserveBook: $e');
    }
  }

  Future<void> saveReservedBook(Book book) async {
    final prefs = await SharedPreferences.getInstance();
    final reservedBooksString = prefs.getString('reservedBooks') ?? '[]';
    final List<dynamic> reservedBooksJson = json.decode(reservedBooksString);

    reservedBooksJson.add(book.toJson());

    await prefs.setString('reservedBooks', json.encode(reservedBooksJson));
  }

  // Méthode pour ajouter un livre à la wishlist
  Future<void> addToWishlist(String bookId) async {
    try {
      final apiUrl = "http://10.0.2.2:9090/api/wishlist/$bookId";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Ajouter le livre à la liste locale de wishlist immédiatement
        setState(() {
          final bookToAdd = books.firstWhere((book) => book.id == bookId);
          wishlist.add(bookToAdd);
        });

        // Afficher un message de succès
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Book added to wishlist successfully.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

        print('Book added to wishlist');
      } else {
        throw Exception('Failed to add book to wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during addToWishlist: $e');
    }
  }

  // Méthode pour supprimer un livre de la wishlist
  Future<void> removeFromWishlist(String bookId) async {
    try {
      final apiUrl = "http://10.0.2.2:9090/api/wishlist/$bookId";
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('Book removed from wishlist');
        fetchWishlist(); // Rafraîchir la wishlist après la suppression
      } else {
        throw Exception('Failed to remove book from wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during removeFromWishlist: $e');
    }
  }


  // Méthode pour récupérer la wishlist depuis l'API
  Future<void> fetchWishlist() async {
    try {
      final apiUrl = "http://10.0.2.2:9090/api/wishlist";
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['wishlist'];
        setState(() {
          wishlist = responseData.map((book) => Book.fromJson(book)).toList();
        });
      } else {
        throw Exception('Failed to fetch wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during fetchWishlist: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books', textAlign: TextAlign.center),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title, author, or category',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    fetchBooks(_searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                fetchBooks(value);
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Naviguer vers l'écran de détails du livre quand un livre est tapé
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(
                          book: books[index],
                          reserveBook: reserveBook,
                          updateAvailability: (bool available) {
                            setState(() {
                              books[index].available = available;
                            });
                          },
                          addToWishlist: addToWishlist,
                          removeFromWishlist: removeFromWishlist,
                          isInWishlist: wishlist.any((wishlistBook) =>
                          wishlistBook.id == books[index].id),
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                      NetworkImage(books[index].imageUrl),
                    ),
                    title: Text(books[index].title),
                    subtitle: Text(books[index].author),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/listpost');
              break;
          /*case 1:
              Navigator.pushNamed(context, '/adminEvent');
              break;
            case 2:
              Navigator.pushNamed(context, '/events');
              break;*/
            case 1:
              Navigator.pushNamed(context, '/profile');
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservedBooksPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WishlistScreen(
                    wishlist: wishlist,
                    removeFromWishlist: removeFromWishlist,
                  ),
                ),
              );
              break;
            default:
          }
        },
      ),
    );
  }
}


class BookDetailsScreen extends StatelessWidget {
  final Book book;
  final Function(String) reserveBook;
  final Function(bool) updateAvailability;
  final Function(String) addToWishlist; // Add this
  final Function(String) removeFromWishlist; // Add this
  final bool isInWishlist; // Add this to check if the book is in the wishlist

  BookDetailsScreen({
    required this.book,
    required this.reserveBook,
    required this.updateAvailability,
    required this.addToWishlist, // Add this
    required this.removeFromWishlist, // Add this
    required this.isInWishlist, // Add this

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Author: ${book.author}'),
            Text('Year: ${book.year.toString()}'),
            Text('Available: ${book.available ? 'Yes' : 'No'}'),
            Text('Summary: ${book.summary}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Réserver le livre
                reserveBook(book.id);
                // Update local availability
                updateAvailability(false);
              },
              child: Text('Reserve Book'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isInWishlist) {
                  removeFromWishlist(book.id);
                } else {
                  addToWishlist(book.id);
                }
              },
              child: Text(
                  isInWishlist ? 'Remove from Wishlist' : 'Add to Wishlist'),
            ),
          ],
        ),
      ),
    );
  }}
class WishlistScreen extends StatelessWidget {
  final List<Book> wishlist;
  final Function(String) removeFromWishlist;

  WishlistScreen({required this.wishlist, required this.removeFromWishlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(wishlist[index].imageUrl),
            ),
            title: Text(wishlist[index].title),
            subtitle: Text(wishlist[index].author),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () {
                removeFromWishlist(wishlist[index].id);
              },
            ),
          );
        },
      ),
    );
  }
}
