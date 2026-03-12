import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/auth/auth_repository.dart';
import '../../repository/auth/mock_auth_repository.dart';
import '../environment.dart';
import '../logger/talker_config.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  TalkerConfig.info('Setting up service locator...');

  // Register Talker
  getIt.registerSingleton(TalkerConfig.instance);

  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register repositories based on environment
  if (EnvironmentConfig.useMockData) {
    TalkerConfig.info('Registering mock repositories');
    getIt.registerLazySingleton<AuthRepository>(
      () => MockAuthRepository(getIt<SharedPreferences>()),
    );
  } else {
    // TODO: Register real repositories when API is ready
    TalkerConfig.info('Real API repositories not yet implemented');
  }

  TalkerConfig.info('Service locator setup complete');
}
