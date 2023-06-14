import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'my_database.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late MyDatabase _database;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<void> _initDatabase() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final databasePath = appDocDir.path;
    _database = MyDatabase();
    await _database.open(databasePath);
  }

  Future<void> _registerUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final newUser = User(
      username: username,
      password: password,
    );

    await _database.insertUser(newUser);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cadastro realizado'),
        content: Text('Usuário cadastrado com sucesso.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nome de usuário',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
