enum Environment {
  production,
  staging,
  debug,
  mock;

  bool get isProduction => this == Environment.production;
  bool get isStaging => this == Environment.staging;
  bool get isDebug => this == Environment.debug;
  bool get isMock => this == Environment.mock;

  bool get isRelease => this == Environment.production || this == Environment.staging;
  bool get isDevelopment => this == Environment.debug || this == Environment.mock;

  String get name {
    switch (this) {
      case Environment.production:
        return 'Production';
      case Environment.staging:
        return 'Staging';
      case Environment.debug:
        return 'Debug';
      case Environment.mock:
        return 'Mock';
    }
  }

  String get displayName {
    switch (this) {
      case Environment.production:
        return '🟢 PROD';
      case Environment.staging:
        return '🟡 STG';
      case Environment.debug:
        return '🔵 DEBUG';
      case Environment.mock:
        return '🟣 MOCK';
    }
  }
}
