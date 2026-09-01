import 'package:flutter/foundation.dart';
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
              onPressed: () {
                signUpUser(_emailController.text, _passwordController.text);
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                signInUser(_emailController.text, _passwordController.text);
              },
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () {
                signOutUser();
              },
              child: const Text('Sign Out'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _signInWithGoogle();
              },
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUpUser(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        debugPrint('User signed up successfully!');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful! Please check your email or sign in.')),
        );
      }
    } on AuthException catch (e) {
      debugPrint('Auth error signing up: ${e.message}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      debugPrint('Error signing up: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing up: $e')),
      );
    }
  }

  Future<void> signInUser(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        debugPrint('User signed in successfully!');
        if (!mounted) return;
        context.go(RouteNameConstant.employeeList);
      }
    } on AuthException catch (e) {
      debugPrint('Auth error signing in: ${e.message}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      debugPrint('Error signing in: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in: $e')),
      );
    }
  }

  Future<void> signOutUser() async {
    await Supabase.instance.client.auth.signOut(scope: SignOutScope.global);
  }

  // Method to sign in with Google
  Future<void> _signInWithGoogle() async {
    try {
      final uri = Uri.base;
      String baseUrl = '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}/#';

      final response = await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? (baseUrl + RouteNameConstant.employeeList) : null,
        authScreenLaunchMode: LaunchMode.platformDefault,
      );

      if (response != true) {
        debugPrint('Error signing in: $response');
      }
    } catch (e) {
      debugPrint('Error during Google sign-in: $e');
    }
  }
}
