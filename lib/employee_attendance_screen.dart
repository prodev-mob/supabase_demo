import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  final String employeeId;
  final String employeeName;

  EmployeeAttendanceScreen({required this.employeeId, required this.employeeName});

  @override
  _EmployeeAttendanceScreenState createState() => _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    _fetchAttendanceRecords();
  }

  // Fetch attendance data for the selected employee, sorted by latest date first
  Future<void> _fetchAttendanceRecords() async {
    final response = await supabase
        .from('attendance')
        .select()
        .eq('employee_id', widget.employeeId)
        .order('date', ascending: false); // Sort by date, latest first

    if (response.isNotEmpty) {
      setState(() {
        attendanceRecords = response;
      });
    } else {
      // print('Error fetching attendance records: ${response.error?.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.employeeName} Attendance'),
      ),
      body: attendanceRecords.isEmpty
          ? Center(child: Text('No attendance records found for this employee.'))
          : ListView.builder(
        itemCount: attendanceRecords.length,
        itemBuilder: (context, index) {
          final record = attendanceRecords[index];
          final date = DateTime.parse(record['date']);
          final checkIn = record['check_in'] ;
          final checkOut = record['check_out'];

          return ListTile(
            title: Text(
              'Date: ${date.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (checkIn != null) Text('Check-in: ${checkIn}'),
                if (checkOut != null) Text('Check-out: ${checkOut}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
