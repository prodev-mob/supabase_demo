import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEditAttendanceScreen extends StatefulWidget {
  final String employeeId;
  final String employeeName;

  const AddEditAttendanceScreen({super.key, required this.employeeId, required this.employeeName});

  @override
  State<AddEditAttendanceScreen> createState() => _AddEditAttendanceScreenState();
}

class _AddEditAttendanceScreenState extends State<AddEditAttendanceScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  DateTime? selectedDate;
  TimeOfDay? checkInTime;
  TimeOfDay? checkOutTime;

  Future<void> _addEditAttendance() async {
    final checkInDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      checkInTime!.hour,
      checkInTime!.minute,
    );

    final checkOutDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      checkOutTime!.hour,
      checkOutTime!.minute,
    );

    final response = await supabase.from('attendance').insert({
      'employee_id': widget.employeeId,
      'date': DateFormat("yyyy-MM-dd").format(selectedDate!),
      'check_in': DateFormat("hh:mm:ss").format(checkInDateTime),
      'check_out': DateFormat("hh:mm:ss").format(checkOutDateTime),
    }).select();

    if (response.isNotEmpty) {
      Navigator.pop(context); // Go back to the previous screen
    } else {
      // print('Error adding/editing attendance: ${response.error?.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Attendance for ${widget.employeeName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Select Date'),
              subtitle: Text(selectedDate != null
                  ? selectedDate!.toLocal().toString().split(' ')[0]
                  : 'No date selected'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Select Check-In Time'),
              subtitle: Text(checkInTime != null
                  ? checkInTime!.format(context)
                  : 'No check-in time selected'),
              trailing: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      checkInTime = time;
                    });
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Select Check-Out Time'),
              subtitle: Text(checkOutTime != null
                  ? checkOutTime!.format(context)
                  : 'No check-out time selected'),
              trailing: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      checkOutTime = time;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedDate != null && checkInTime != null && checkOutTime != null) {
                  _addEditAttendance();
                }
              },
              child: const Text('Save Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
