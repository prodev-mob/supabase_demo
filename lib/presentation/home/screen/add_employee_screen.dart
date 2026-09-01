import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_demo/navigation/route_name_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';

  Future<void> _addEmployee() async {
    try {
      final response = await supabase.from('employees').insert({
        'name': name,
        'email': email,
      }).select();

      if (response.isNotEmpty) {
        if (!mounted) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(RouteNameConstant.employeeList);
        }
      }
    } on PostgrestException catch (e) {
      final errorMsg = e.message.isNotEmpty ? e.message : (e.details?.toString() ?? e.code ?? 'Unknown database error');
      debugPrint('Postgrest error adding employee: code=${e.code}, message=${e.message}, details=${e.details}, hint=${e.hint}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database error ($errorMsg)')),
      );
    } catch (e) {
      debugPrint('Error adding employee: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding employee: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addEmployee();
                  }
                },
                child: const Text('Add Employee'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
