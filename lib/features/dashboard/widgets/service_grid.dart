import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/route/route_names.dart';

class _ServiceOption {
  final IconData icon;
  final String label;
  final String route;
  final bool hasDownloadOptions;

  const _ServiceOption({
    required this.icon,
    required this.label,
    required this.route,
    this.hasDownloadOptions = false,
  });
}

const _services = [
  _ServiceOption(icon: Icons.people, label: 'Team Directory', route: RouteNames.teamDirectory),
  _ServiceOption(icon: Icons.policy, label: 'Policies', route: RouteNames.policies),
  _ServiceOption(icon: Icons.card_giftcard, label: 'Benefits', route: RouteNames.benefits),
  _ServiceOption(icon: Icons.event_available, label: 'Leave/Attendance', route: RouteNames.leaveAttendance),
  _ServiceOption(icon: Icons.attach_money, label: 'Compensation', route: RouteNames.compensation),
  _ServiceOption(icon: Icons.emoji_events, label: 'Recognition - GEM', route: RouteNames.recognition),
  _ServiceOption(icon: Icons.favorite, label: 'Health & Wellness', route: RouteNames.ayushHealth),
  _ServiceOption(icon: Icons.calendar_today, label: 'Holiday Calendar', route: RouteNames.holidayCalendar),
  _ServiceOption(icon: Icons.folder, label: 'Documents', route: RouteNames.documents, hasDownloadOptions: true),
  _ServiceOption(icon: Icons.flight, label: 'Travel', route: RouteNames.travel),
  _ServiceOption(icon: Icons.school, label: 'BOLT - Start Learning!', route: RouteNames.bolt),
  _ServiceOption(icon: Icons.lightbulb, label: 'Idea Management Portal', route: RouteNames.dashboard),
];

class ServiceGrid extends StatefulWidget {
  const ServiceGrid({super.key});

  @override
  State<ServiceGrid> createState() => _ServiceGridState();
}

class _ServiceGridState extends State<ServiceGrid> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _query = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_ServiceOption> get _filtered {
    if (_query.isEmpty) return _services;
    final lower = _query.toLowerCase();
    return _services.where((s) => s.label.toLowerCase().contains(lower)).toList();
  }

  void _showDocumentDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Documents'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download, color: AppColors.blue),
              title: const Text('About Bajaj Auto'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading About Bajaj Auto...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: AppColors.blue),
              title: const Text('Code of Conduct'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading Code of Conduct...')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, _ServiceOption service) {
    return InkWell(
      onTap: () {
        if (service.hasDownloadOptions) {
          _showDocumentDownloadDialog(context);
        } else {
          context.go(service.route);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(service.icon, size: 48, color: AppColors.blue),
            const SizedBox(height: 12),
            Text(
              service.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Search services, documents',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          const Center(child: Text('No services found'))
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 600
                      ? 3
                      : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) => _buildTile(context, filtered[index]),
              );
            },
          ),
      ],
    );
  }
}
