import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_demo/navigation/route_name_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> employees = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchEmployees();
      insertUserIfNotFound();
    });

    super.initState();
  }

  Future<void> insertUserIfNotFound() async {
    final SupabaseClient supabase = Supabase.instance.client;

    // Get the currently logged-in user from Supabase Auth
    final User? user = supabase.auth.currentUser;

    if (user == null) {
      print('No user is currently logged in.');
      return;
    }

    print("Name :: :: :: :: ${user.toJson()}");

    final String email = user.email ?? '';
    final String userId = user.id;
    final String name = user.userMetadata?['full_name'] ?? "";
    final String image = user.userMetadata?['picture'] ?? "";

    try {
      // Check if the user's email already exists in the 'users' table
      final response = await supabase.from('users').select('id').eq('email', email);

      if (response.isNotEmpty) {
        // User already exists in the table
        print('User with email $email already exists. No need to insert.');
      } else {
        // User doesn't exist, insert the new user data into the 'users' table
        await supabase.from('users').insert({
          'id': userId,
          'name': name,
          'email': email,
          'profile_pic': image,
        });

        print('New user inserted with email $email.');
      }
    } catch (e) {
      print('Error during user check and insertion: $e');
    }
  }

  Future<void> _fetchEmployees() async {
    final response = await Supabase.instance.client.from('employees').select();

    if (response.isNotEmpty) {
      setState(() {
        employees = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 26),
            child: IconButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                context.go(RouteNameConstant.auth);
              },
              icon: const Icon(
                Icons.logout,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: employees.isEmpty
          ? const Center(
              child: Text('No employees found.'),
            )
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return ListTile(
                  title: Text(employee['name']),
                  subtitle: Text(employee['email']),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      context.go(
                        RouteNameConstant.addEmployeeAttendance.replaceFirst(":employeeID", employee['id']),
                        extra: employee['name'],
                      );
                    },
                  ),
                  onTap: () {
                    context.go(
                      RouteNameConstant.employeeAttendance.replaceFirst(":employeeID", employee['id']),
                      extra: employee['name'],
                    );
                  },
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                context.go(RouteNameConstant.addEmployee);
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                context.go(RouteNameConstant.chatUsers);
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                child: const Icon(
                  Icons.chat,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
