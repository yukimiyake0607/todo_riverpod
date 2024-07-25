// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hiveTodoServiceHash() => r'055a5351ae1bd522870ce59ea60fce336af5804b';

/// See also [hiveTodoService].
@ProviderFor(hiveTodoService)
final hiveTodoServiceProvider = AutoDisposeProvider<HiveTodoService>.internal(
  hiveTodoService,
  name: r'hiveTodoServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hiveTodoServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HiveTodoServiceRef = AutoDisposeProviderRef<HiveTodoService>;
String _$todoListHash() => r'2cd2687a49b8f110e4087be008edf90ba14aa79e';

/// See also [TodoList].
@ProviderFor(TodoList)
final todoListProvider =
    AutoDisposeNotifierProvider<TodoList, List<TodoModel>>.internal(
  TodoList.new,
  name: r'todoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todoListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodoList = AutoDisposeNotifier<List<TodoModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
