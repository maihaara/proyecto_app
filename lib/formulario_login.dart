import 'package:flutter/material.dart';
import 'package:app1/list_items.dart';

class MyCustomFormWithNavigation extends StatefulWidget {
  const MyCustomFormWithNavigation({super.key});

  @override
  _MyCustomFormWithNavigationState createState() => _MyCustomFormWithNavigationState();
}

class _MyCustomFormWithNavigationState extends State<MyCustomFormWithNavigation> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SpacedItemsList()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: const Center(child: Text('Bienvenido')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Por favor ingresa su usuario' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Por favor ingrese el password' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Ingresar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



