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

String _$TodosHash() => r'724417cd95754058abc4bbeedd64ab7c83d7c2d3';

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

String _$filteredTodosHash() => r'2d1bb1509f88f17d5893f043b78bd6f915551c2b';

/// See also [filteredTodos].
final filteredTodosProvider = AutoDisposeProvider<List<Todo>>(
  filteredTodos,
  name: r'filteredTodosProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredTodosHash,
);
typedef FilteredTodosRef = AutoDisposeProviderRef<List<Todo>>;
String _$todosByDayHash() => r'a494cdb07de75b23dc51960bee5c8fd1cf3d8037';

/// See also [todosByDay].
final todosByDayProvider = AutoDisposeProvider<Map<DateTime, List<Todo>>>(
  todosByDay,
  name: r'todosByDayProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todosByDayHash,
);
typedef TodosByDayRef = AutoDisposeProviderRef<Map<DateTime, List<Todo>>>;
String _$todoHash() => r'0b44a670f6f5f0c20213cdf6277ea96a2415672a';

/// See also [todo].
class TodoProvider extends AutoDisposeProvider<Todo> {
  TodoProvider(
    this.todoId,
  ) : super(
          (ref) => todo(
            ref,
            todoId,
          ),
          from: todoProvider,
          name: r'todoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$todoHash,
        );

  final int todoId;

  @override
  bool operator ==(Object other) {
    return other is TodoProvider && other.todoId == todoId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, todoId.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef TodoRef = AutoDisposeProviderRef<Todo>;

/// See also [todo].
final todoProvider = TodoFamily();

class TodoFamily extends Family<Todo> {
  TodoFamily();

  TodoProvider call(
    int todoId,
  ) {
    return TodoProvider(
      todoId,
    );
  }

  @override
  AutoDisposeProvider<Todo> getProviderOverride(
    covariant TodoProvider provider,
  ) {
    return call(
      provider.todoId,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'todoProvider';
}
