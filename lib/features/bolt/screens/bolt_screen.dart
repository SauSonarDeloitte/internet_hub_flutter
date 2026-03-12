import 'package:flutter/material.dart';
import '../../../shared/widgets/layout/app_shell.dart';

class BoltScreen extends StatelessWidget {
  const BoltScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShell(
      title: 'Bolt',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bolt, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Bolt', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Coming in Phase 3', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
