import 'package:flutter/material.dart';
import '../models/dashboard_data.dart';

class LeaveBalanceWidget extends StatelessWidget {
  final LeaveBalance leaveBalance;

  const LeaveBalanceWidget({
    super.key,
    required this.leaveBalance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event_available,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Leave Balance',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildLeaveItem(
                    context,
                    'Available',
                    leaveBalance.availableLeaves,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildLeaveItem(
                    context,
                    'Used',
                    leaveBalance.usedLeaves,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildLeaveItem(
                    context,
                    'Pending',
                    leaveBalance.pendingLeaves,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildLeaveItem(
                    context,
                    'Total',
                    leaveBalance.totalLeaves,
                    colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: leaveBalance.usedLeaves / leaveBalance.totalLeaves,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                leaveBalance.usedLeaves / leaveBalance.totalLeaves > 0.7
                    ? Colors.orange
                    : colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveItem(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value.toString(),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
