enum Environment {
  dev,
  staging,
  production,
}

class EnvironmentConfig {
  static Environment _currentEnvironment = Environment.dev;
  
  static Environment get current => _currentEnvironment;
  
  static bool get isDev => _currentEnvironment == Environment.dev;
  static bool get isStaging => _currentEnvironment == Environment.staging;
  static bool get isProduction => _currentEnvironment == Environment.production;
  
  static bool get useMockData => isDev;
  
  static void setEnvironment(Environment env) {
    _currentEnvironment = env;
  }
}
