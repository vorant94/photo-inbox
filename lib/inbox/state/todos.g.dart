// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

String _$TodosHash() => r'2b1fde6ceba700fad1fcfda31481e85b34d332f4';

/// See also [Todos].
final todosProvider = AutoDisposeNotifierProvider<Todos, List<Todo>>(
  Todos.new,
  name: r'todosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$TodosHash,
);
typedef TodosRef = AutoDisposeNotifierProviderRef<List<Todo>>;

abstract class _$Todos extends AutoDisposeNotifier<List<Todo>> {
  @override
  List<Todo> build();
}

String _$filteredTodosHash() => r'a567a3c42109cfe2f0563538a42f2b1cfed9b1e9';

/// See also [filteredTodos].
final filteredTodosProvider = AutoDisposeProvider<List<Todo>>(
  filteredTodos,
  name: r'filteredTodosProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredTodosHash,
);
typedef FilteredTodosRef = AutoDisposeProviderRef<List<Todo>>;
String _$todoDaysHash() => r'e78f925b920aeb89039240c87cad6feaea466ea0';

/// See also [todoDays].
final todoDaysProvider = AutoDisposeProvider<List<DateTime>>(
  todoDays,
  name: r'todoDaysProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todoDaysHash,
);
typedef TodoDaysRef = AutoDisposeProviderRef<List<DateTime>>;
String _$todosByDayHash() => r'ae7450e990a9feac90b8d903734a59f9eec959c4';

/// See also [todosByDay].
class TodosByDayProvider extends AutoDisposeProvider<List<Todo>> {
  TodosByDayProvider(
    this.day,
  ) : super(
          (ref) => todosByDay(
            ref,
            day,
          ),
          from: todosByDayProvider,
          name: r'todosByDayProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$todosByDayHash,
        );

  final DateTime day;

  @override
  bool operator ==(Object other) {
    return other is TodosByDayProvider && other.day == day;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, day.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef TodosByDayRef = AutoDisposeProviderRef<List<Todo>>;

/// See also [todosByDay].
final todosByDayProvider = TodosByDayFamily();

class TodosByDayFamily extends Family<List<Todo>> {
  TodosByDayFamily();

  TodosByDayProvider call(
    DateTime day,
  ) {
    return TodosByDayProvider(
      day,
    );
  }

  @override
  AutoDisposeProvider<List<Todo>> getProviderOverride(
    covariant TodosByDayProvider provider,
  ) {
    return call(
      provider.day,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'todosByDayProvider';
}
