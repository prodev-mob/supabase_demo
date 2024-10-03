import 'package:flutter/material.dart';
import 'package:supabase_demo/employees_list_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signUpUser(String email, String password) async {
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      // print('Error: ${response.error!.message}');
    } else {
      print('User signed up successfully!');
    }
  }

  Future<void> signInUser(String email, String password) async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      // print('Error: ${response.error!.message}');
    } else {
      print('User signed in successfully!');
      // Navigate to HomePage after successful sign-in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const EmployeeListScreen()),
      );
    }
  }

  Future<void> signOutUser() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Supabase Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await signOutUser();
                await signInUser(_emailController.text, _passwordController.text);
              },
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () async {
                await signUpUser(_emailController.text, _passwordController.text);
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}