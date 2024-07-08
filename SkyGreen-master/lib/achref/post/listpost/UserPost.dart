import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PostList.dart';

class ReservedBooksPage extends StatefulWidget {
  @override
  _ReservedBooksPageState createState() => _ReservedBooksPageState();
}

class _ReservedBooksPageState extends State<ReservedBooksPage> {
  List<Book> reservedBooks = [];

  @override
  void initState() {
    super.initState();
    fetchReservedBooks();
  }

  Future<void> fetchReservedBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final reservedBooksString = prefs.getString('reservedBooks') ?? '[]';
    final List<dynamic> reservedBooksJson = json.decode(reservedBooksString);

    setState(() {
      reservedBooks = reservedBooksJson.map((json) => Book.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserved Books'),
      ),
      body: reservedBooks.isEmpty
          ? Center(child: Text('No reserved books yet.'))
          : ListView.builder(
        itemCount: reservedBooks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(reservedBooks[index].imageUrl),
            ),
            title: Text(reservedBooks[index].title),
            subtitle: Text(reservedBooks[index].author),
          );
        },
      ),
    );
  }
}
