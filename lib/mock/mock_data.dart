import 'dart:math';

class MockData {
  static final Random _random = Random();

  /// Simulates network delay
  static Future<void> simulateDelay({int minMs = 300, int maxMs = 800}) async {
    final delay = minMs + _random.nextInt(maxMs - minMs);
    await Future.delayed(Duration(milliseconds: delay));
  }

  /// Simulates random errors for testing
  static void simulateRandomError({double errorRate = 0.1}) {
    if (_random.nextDouble() < errorRate) {
      throw Exception('Simulated network error');
    }
  }

  /// Generate random ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        _random.nextInt(10000).toString();
  }

  /// Random boolean
  static bool randomBool() => _random.nextBool();

  /// Random int in range
  static int randomInt(int min, int max) => min + _random.nextInt(max - min + 1);

  /// Random double in range
  static double randomDouble(double min, double max) =>
      min + _random.nextDouble() * (max - min);

  /// Pick random item from list
  static T randomItem<T>(List<T> items) =>
      items[_random.nextInt(items.length)];

  /// Generate random date in range
  static DateTime randomDate(DateTime start, DateTime end) {
    final diff = end.difference(start).inDays;
    final randomDays = _random.nextInt(diff);
    return start.add(Duration(days: randomDays));
  }

  // Common mock data
  static const List<String> firstNames = [
    'John', 'Jane', 'Michael', 'Sarah', 'David', 'Emily', 'Robert', 'Lisa',
    'James', 'Mary', 'William', 'Patricia', 'Richard', 'Jennifer', 'Thomas',
    'Linda', 'Charles', 'Elizabeth', 'Daniel', 'Susan'
  ];

  static const List<String> lastNames = [
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller',
    'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez',
    'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin'
  ];

  static const List<String> departments = [
    'Engineering', 'Human Resources', 'Finance', 'Marketing', 'Sales',
    'Operations', 'IT', 'Customer Support', 'Product', 'Design'
  ];

  static const List<String> designations = [
    'Manager', 'Senior Manager', 'Director', 'Senior Director', 'VP',
    'Engineer', 'Senior Engineer', 'Lead Engineer', 'Analyst', 'Specialist',
    'Coordinator', 'Associate', 'Executive', 'Consultant'
  ];

  static String randomName() {
    return '${randomItem(firstNames)} ${randomItem(lastNames)}';
  }

  static String randomEmail(String name) {
    return '${name.toLowerCase().replaceAll(' ', '.')}@company.com';
  }
}
