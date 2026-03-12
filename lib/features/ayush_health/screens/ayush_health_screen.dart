import 'package:flutter/material.dart';
import '../../../shared/widgets/layout/app_shell.dart';

class AyushHealthScreen extends StatelessWidget {
  const AyushHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShell(
      title: 'Ayush Health',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.health_and_safety, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Ayush Health', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Coming in Phase 3', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
