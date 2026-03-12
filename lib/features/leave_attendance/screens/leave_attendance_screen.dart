import 'package:flutter/material.dart';
import '../../../shared/widgets/layout/app_shell.dart';

class LeaveAttendanceScreen extends StatelessWidget {
  const LeaveAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShell(
      title: 'Leave/Attendance',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Leave/Attendance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Coming in Phase 3', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
