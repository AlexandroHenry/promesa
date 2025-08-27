// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_schedule_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scheduleDataSourceHash() =>
    r'f24cd2afb8cd9a7bedea491cdf98749d590d27f3';

/// See also [scheduleDataSource].
@ProviderFor(scheduleDataSource)
final scheduleDataSourceProvider =
    AutoDisposeProvider<MockScheduleDataSource>.internal(
  scheduleDataSource,
  name: r'scheduleDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ScheduleDataSourceRef = AutoDisposeProviderRef<MockScheduleDataSource>;
String _$scheduleRepositoryHash() =>
    r'494b6a93c5f92baf3122c32cc32da34d636cb8c7';

/// See also [scheduleRepository].
@ProviderFor(scheduleRepository)
final scheduleRepositoryProvider =
    AutoDisposeProvider<ScheduleRepository>.internal(
  scheduleRepository,
  name: r'scheduleRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ScheduleRepositoryRef = AutoDisposeProviderRef<ScheduleRepository>;
String _$createScheduleUseCaseHash() =>
    r'63e6c2cb918255e4fb0afd104795b6178acc0f9f';

/// See also [createScheduleUseCase].
@ProviderFor(createScheduleUseCase)
final createScheduleUseCaseProvider =
    AutoDisposeProvider<CreateScheduleUseCase>.internal(
  createScheduleUseCase,
  name: r'createScheduleUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createScheduleUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CreateScheduleUseCaseRef
    = AutoDisposeProviderRef<CreateScheduleUseCase>;
String _$addScheduleNotifierHash() =>
    r'8c9af43c7fdf48cfa823e2e5a5af6ffc9c78fb75';

/// See also [AddScheduleNotifier].
@ProviderFor(AddScheduleNotifier)
final addScheduleNotifierProvider =
    AutoDisposeNotifierProvider<AddScheduleNotifier, AddScheduleState>.internal(
  AddScheduleNotifier.new,
  name: r'addScheduleNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addScheduleNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddScheduleNotifier = AutoDisposeNotifier<AddScheduleState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
