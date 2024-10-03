import 'package:flutter/material.dart';
import 'package:supabase_demo/add_employee_attendence_screen.dart';
import 'package:supabase_demo/employee_attendance_screen.dart';
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

    print("Response :: :: : : : : $response");
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
        title: Text('Employee List'),
      ),
      body: employees.isEmpty
          ? Center(child: Text('No employees found.'))
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return ListTile(
                  title: Text(employee['name']),
                  subtitle: Text(employee['email']),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditAttendanceScreen(
                            employeeId: employee['id'],
                            employeeName: employee['name'],
                          ),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeAttendanceScreen(
                          employeeId: employee['id'],
                          employeeName: employee['name'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_employee').then((value) => _fetchEmployees());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
