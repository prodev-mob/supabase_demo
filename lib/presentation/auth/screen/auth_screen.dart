import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_demo/navigation/route_name_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await signOutUser();
                await signInUser(_emailController.text, _passwordController.text);
              },
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () async {
                await signUpUser(_emailController.text, _passwordController.text);
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(
              height: 34,
            ),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: const Text('Sign in with Google'),
            ),
            const SizedBox(
              height: 34,
            ),
            ElevatedButton(
              onPressed: signOutUser,
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUpUser(String email, String password) async {
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      // print('Error: ${response.error!.message}');
    } else {
      debugPrint('User signed up successfully!');
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
      debugPrint('User signed in successfully!');
      // Navigate to HomePage after successful sign-in
      context.go(RouteNameConstant.employeeList);
    }
  }

  Future<void> signOutUser() async {
    await Supabase.instance.client.auth.signOut(scope: SignOutScope.global);
  }

  // Method to sign in with Google
  Future<void> _signInWithGoogle() async {
    try {
      final url = html.window.location.href;
      Uri uri = Uri.parse(url);
      String baseUrl = '${uri.scheme}://${uri.host}:${uri.port}/#';

      final response = await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: baseUrl + RouteNameConstant.employeeList,
        authScreenLaunchMode: LaunchMode.platformDefault,
      );

      if (response != true) {
        debugPrint('Error signing in: $response');
      } else {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => const EmployeeListScreen()),
        // );
      }
    } catch (e) {
      debugPrint('Error during Google sign-in: $e');
    }
  }
}
