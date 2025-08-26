// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authDataSourceHash() => r'd8f9e555970257515005f1709698e4283a9105a7';

/// Auth DataSource Provider
///
/// Copied from [authDataSource].
@ProviderFor(authDataSource)
final authDataSourceProvider = AutoDisposeProvider<AuthDataSource>.internal(
  authDataSource,
  name: r'authDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthDataSourceRef = AutoDisposeProviderRef<AuthDataSource>;
String _$authRepositoryHash() => r'67fae9be7eacc87594eb3de058d357c2492e145b';

/// Auth Repository Provider
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$loginUseCaseHash() => r'79d69a305a59bafbc3c85224c3fc429a94106709';

/// Login UseCase Provider
///
/// Copied from [loginUseCase].
@ProviderFor(loginUseCase)
final loginUseCaseProvider = AutoDisposeProvider<LoginUseCase>.internal(
  loginUseCase,
  name: r'loginUseCaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loginUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LoginUseCaseRef = AutoDisposeProviderRef<LoginUseCase>;
String _$getUserInfoUseCaseHash() =>
    r'85fd43a732bd82015be106a50089aad525e65377';

/// Get User Info UseCase Provider
///
/// Copied from [getUserInfoUseCase].
@ProviderFor(getUserInfoUseCase)
final getUserInfoUseCaseProvider =
    AutoDisposeProvider<GetUserInfoUseCase>.internal(
  getUserInfoUseCase,
  name: r'getUserInfoUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getUserInfoUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetUserInfoUseCaseRef = AutoDisposeProviderRef<GetUserInfoUseCase>;
String _$refreshTokenUseCaseHash() =>
    r'c7b9fcd882ad834630c855001a5c7cf863f190ef';

/// Refresh Token UseCase Provider
///
/// Copied from [refreshTokenUseCase].
@ProviderFor(refreshTokenUseCase)
final refreshTokenUseCaseProvider =
    AutoDisposeProvider<RefreshTokenUseCase>.internal(
  refreshTokenUseCase,
  name: r'refreshTokenUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$refreshTokenUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RefreshTokenUseCaseRef = AutoDisposeProviderRef<RefreshTokenUseCase>;
String _$logoutUseCaseHash() => r'2703fdf3e76d109782e5df6e5f948f7ad9120701';

/// Logout UseCase Provider
///
/// Copied from [logoutUseCase].
@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = AutoDisposeProvider<LogoutUseCase>.internal(
  logoutUseCase,
  name: r'logoutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$logoutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LogoutUseCaseRef = AutoDisposeProviderRef<LogoutUseCase>;
String _$authNotifierHash() => r'a94265672d345c9868c85d56834befd619db43d3';

/// Auth Provider (상태 관리)
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, AuthState>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
