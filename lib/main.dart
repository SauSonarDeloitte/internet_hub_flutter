import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'repository/auth/auth_repository.dart';
import 'shared/theme/app_theme.dart';
import 'utils/di/service_locator.dart';
import 'utils/environment.dart';
import 'utils/logger/talker_bloc_observer.dart';
import 'utils/logger/talker_config.dart';
import 'utils/router/app_router.dart';
import 'utils/storage/web_storage_directory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set environment to dev (mock mode)
  EnvironmentConfig.setEnvironment(Environment.dev);
  TalkerConfig.info('App starting in ${EnvironmentConfig.current} mode');

  // Initialize HydratedBloc storage with platform-specific handling
  if (kIsWeb) {
    // For web, use custom WebStorageDirectory that works with IndexedDB
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: WebStorageDirectory(),
    );
  } else {
    // For mobile/desktop, use path_provider with HydratedStorageDirectory wrapper
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
        (await getTemporaryDirectory()).path,
      ),
    );
  }

  // Set up Bloc observer
  Bloc.observer = AppBlocObserver();

  // Set up dependency injection
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(getIt<AuthRepository>())
      ..add(const AuthCheckRequested());
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'HR App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.createRouter(_authBloc),
      ),
    );
  }
}
