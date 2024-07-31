// profile_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchUser(int userId) async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user');
  }
}

