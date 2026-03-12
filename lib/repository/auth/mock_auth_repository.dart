import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/user_model.dart';
import '../../utils/logger/talker_config.dart';
import '../base_repository.dart';
import 'auth_repository.dart';

class MockAuthRepository extends AuthRepository {
  final SharedPreferences _prefs;
  static const String _userKey = 'mock_user';
  
  // Mock credentials
  static const Map<String, String> _mockCredentials = {
    'demo@company.com': 'password123',
    'admin@company.com': 'admin123',
    'user@company.com': 'user123',
    'test@company.com': 'test123',
  };

  // Mock users
  static final Map<String, UserModel> _mockUsers = {
    'demo@company.com': const UserModel(
      id: '0',
      email: 'demo@company.com',
      name: 'Demo User',
      role: 'employee',
      department: 'Human Resources',
      designation: 'HR Manager',
    ),
    'admin@company.com': const UserModel(
      id: '1',
      email: 'admin@company.com',
      name: 'Admin User',
      role: 'admin',
      department: 'IT',
      designation: 'System Administrator',
    ),
    'user@company.com': const UserModel(
      id: '2',
      email: 'user@company.com',
      name: 'John Doe',
      role: 'employee',
      department: 'Engineering',
      designation: 'Senior Engineer',
    ),
    'test@company.com': const UserModel(
      id: '3',
      email: 'test@company.com',
      name: 'Test User',
      role: 'employee',
      department: 'Marketing',
      designation: 'Marketing Manager',
    ),
  };

  MockAuthRepository(this._prefs);

  @override
  Future<Result<UserModel>> login(String email, String password) async {
    try {
      TalkerConfig.info('Mock login attempt for: $email');
      await simulateNetworkDelay();

      // Validate credentials
      if (!_mockCredentials.containsKey(email)) {
        TalkerConfig.warning('Login failed: User not found');
        return const Failure('User not found');
      }

      if (_mockCredentials[email] != password) {
        TalkerConfig.warning('Login failed: Invalid password');
        return const Failure('Invalid password');
      }

      // Get user
      final user = _mockUsers[email]!;
      
      // Save user to preferences
      await _prefs.setString(_userKey, user.id);
      
      TalkerConfig.info('Login successful for: ${user.name}');
      return Success(user);
    } catch (e, stackTrace) {
      TalkerConfig.error('Login error: $e', stackTrace);
      return Failure('Login failed: $e', error: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      TalkerConfig.info('Mock logout');
      await simulateNetworkDelay(milliseconds: 200);
      
      await _prefs.remove(_userKey);
      
      TalkerConfig.info('Logout successful');
      return const Success(null);
    } catch (e, stackTrace) {
      TalkerConfig.error('Logout error: $e', stackTrace);
      return Failure('Logout failed: $e', error: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<Result<UserModel?>> getCurrentUser() async {
    try {
      final userId = _prefs.getString(_userKey);
      
      if (userId == null) {
        return const Success(null);
      }

      // Find user by ID
      final user = _mockUsers.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw Exception('User not found'),
      );

      return Success(user);
    } catch (e, stackTrace) {
      TalkerConfig.error('Get current user error: $e', stackTrace);
      return Failure('Failed to get user: $e', error: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    try {
      final userId = _prefs.getString(_userKey);
      return Success(userId != null);
    } catch (e, stackTrace) {
      TalkerConfig.error('Check authentication error: $e', stackTrace);
      return Failure('Failed to check authentication: $e', error: e, stackTrace: stackTrace);
    }
  }
}
