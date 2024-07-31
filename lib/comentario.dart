import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchComments(int postId) async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId/comments'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load comments');
  }
}

class ComentarioScreen extends StatefulWidget {
  final int postId;

  const ComentarioScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _ComentarioScreenState createState() => _ComentarioScreenState();
}

class _ComentarioScreenState extends State<ComentarioScreen> {
  late Future<List<dynamic>> _comments;

  @override
  void initState() {
    super.initState();
    _comments = fetchComments(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comentarios')),
      body: FutureBuilder<List<dynamic>>(
        future: _comments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No comments available.'));
          } else {
            final comments = snapshot.data!;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  title: Text(
                    comment['name'],
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    comment['body'],
                    style: const TextStyle(color: Colors.black),
                  )
                );
              },
            );
          }
        },
      ),
    );
  }
}
