import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchPosts() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load posts');
  }
}