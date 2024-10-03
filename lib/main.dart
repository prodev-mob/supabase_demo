import 'package:flutter/material.dart';
import 'package:supabase_demo/authentication_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'add_employee_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'ADD_YOUR_URL',
    anonKey:
        'ADD-YOUR-ANON-KEY',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
      routes: {
        '/add_employee': (context) => const AddEmployeeScreen(),
      },
    );
  }
}
