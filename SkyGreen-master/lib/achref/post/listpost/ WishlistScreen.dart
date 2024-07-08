import 'package:flutter/material.dart';
import 'PostList.dart';

class WishlistScreen extends StatelessWidget {
  final List<Book> wishlist;
  final Function(String) removeFromWishlist;

  WishlistScreen({
    required this.wishlist,
    required this.removeFromWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          final book = wishlist[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                removeFromWishlist(book.id);
              },
            ),
          );
        },
      ),
    );
  }
}
