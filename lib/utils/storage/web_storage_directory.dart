import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Web-specific storage directory for HydratedBloc
/// Uses browser's IndexedDB through Hive
class WebStorageDirectory extends HydratedStorageDirectory {
  WebStorageDirectory() : super('hydrated_bloc_web');
}
