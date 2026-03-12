import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'talker_config.dart';

class AppBlocObserver extends TalkerBlocObserver {
  AppBlocObserver()
      : super(
          talker: TalkerConfig.instance,
          settings: const TalkerBlocLoggerSettings(
            printStateFullData: false,
            printEventFullData: false,
          ),
        );
}
