// screens.dart
import 'package:app1/profile_api.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'comentario.dart'; // Asegúrate de tener esto si usas la pantalla de comentarios

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  late Future<List<dynamic>> _todos;

  @override
  void initState() {
    super.initState();
    _todos = fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TODOs')),
      body: FutureBuilder<List<dynamic>>(
        future: _todos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No TODOs available.'));
          } else {
            final todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  leading: Icon(
                    todo['completed'] ? Icons.check_circle : Icons.circle_outlined,
                    color: todo['completed'] ? Colors.green : Colors.red,
                  ),
                  title: Text(todo['title']),
                  subtitle: Text('ID: ${todo['id']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _user;
  final int _userId = (1 + (10 - 1) * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000); // Generar un ID aleatorio entre 1 y 10

  @override
  void initState() {
    super.initState();
    _user = fetchUser(_userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PROFILE')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data available.'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${user['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Username: ${user['username']}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Email: ${user['email']}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Address:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('  Street: ${user['address']['street']}', style: const TextStyle(fontSize: 16)),
                  Text('  Suite: ${user['address']['suite']}', style: const TextStyle(fontSize: 16)),
                  Text('  City: ${user['address']['city']}', style: const TextStyle(fontSize: 16)),
                  Text('  Zipcode: ${user['address']['zipcode']}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Phone: ${user['phone']}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Website: ${user['website']}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Company:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('  Name: ${user['company']['name']}', style: const TextStyle(fontSize: 16)),
                  Text('  Catch Phrase: ${user['company']['catchPhrase']}', style: const TextStyle(fontSize: 16)),
                  Text('  Business: ${user['company']['bs']}', style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<List<dynamic>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POSTS')),
      body: FutureBuilder<List<dynamic>>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available.'));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Dismissible(
                  key: Key(post['id'].toString()),
                  direction: DismissDirection.horizontal,
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      return true; // Permite que el item sea eliminado
                    } else if (direction == DismissDirection.endToStart) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ComentarioScreen(postId: post['id']),
                        ),
                      );
                      return false; // No elimina el item, solo navega
                    }
                    return false; // Por defecto no se elimina ni navega
                  },
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: const [
                            Icon(Icons.delete, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Eliminar', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.green,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(Icons.comment, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Comentarios', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(id: post['id']),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(post['title']),
                      subtitle: Text(post['body']),
                      trailing: IconButton(
                        icon: const Icon(Icons.share, color: Colors.blue),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Compartir')),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  final int id;

  const PostDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Post')),
      body: Center(
        child: Text(
          'ID del post: $id',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
