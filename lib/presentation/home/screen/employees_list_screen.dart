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
    });

    super.initState();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(RouteNameConstant.addEmployee);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
