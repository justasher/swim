import 'package:swim/src/pool.dart';
import 'package:swim/src/typedefs.dart';

class Provider {
  static final Map<Type, FactoryFunction> _factories = {};
  static final Map<Type, Map<String?, Pool?>> _pools = {};
  static final Map<Type, Map<int?, bool?>> _poolsState = {};
  static final Map<Type, Map<int, int>> _observers = {};

  static void register<T extends Pool>(FactoryFunction<T> factoryFunction) {
    _factories[T] = factoryFunction;
  }

  static T create<T extends Pool>({required T Function() create, String? id, bool? permanent}) {
    var instance = get<T>(id: id);
    if (instance == null) {
      instance = create();
      _add(instance, permanent: permanent, id: id);
    }
    return instance;
  }

  static void _add(Pool pool, {String? id, bool? permanent}) {
    final type = pool.runtimeType;
    _pools.putIfAbsent(type, () => {});
    _pools[type]![id] = pool;
    if (permanent != null) {
      _poolsState.putIfAbsent(type, () => {})[pool.hashCode] = permanent;
    }
  }

  static T? get<T extends Pool>({String? id}) {
    return _pools[T]?[id] as T?;
  }

  static List<T> getAll<T extends Pool>() {
    return _pools[T]?.values.cast<T>().toList() ?? [];
  }

  static void deleteById<T extends Pool>({required String id}) {
    var pool = _pools[T]?.remove(id);
    if (pool != null) {
      _poolsState[T]?.remove(pool.hashCode);
      if (_poolsState[T]?.isEmpty ?? true) {
        _poolsState.remove(T);
      }
    }
  }

  static void registerObserver<T extends Pool>(int hashCode) {
    _observers.putIfAbsent(T, () => {});
    _observers[T]![hashCode] = (_observers[T]![hashCode] ?? 0) + 1;
    _poolsState[T] ??= {};
    _poolsState[T]![hashCode] = false;
  }

  static void unregisterObserver<T extends Pool>(int hashCode) {
    if (!_observers.containsKey(T) || !_observers[T]!.containsKey(hashCode)) {
      return;
    }
    _observers[T]![hashCode] = _observers[T]![hashCode]! - 1;
    if (_observers[T]![hashCode] == 0) {
      _observers[T]!.remove(hashCode);
      var pool = _pools[T]?.values.firstWhere((e) => e?.hashCode == hashCode);
      if (pool != null && _poolsState[T]?[hashCode] != null && !_poolsState[T]![hashCode]!) {
        pool.dispose();
        _pools[T]?.removeWhere((key, value) => value?.hashCode == hashCode);
      }
      if (_observers[T]!.isEmpty) {
        _observers.remove(T);
      }
    }
  }

  static T getAndCreateIfNull<T extends Pool>({String? id, bool? permanent}) {
    var instance = get<T>(id: id);
    if (instance == null) {
      var factory = _factories[T];
      if (factory != null) {
        instance = factory();
        _add(instance!, permanent: permanent, id: id);
      } else {
        throw Exception('Factory for type $T not registered');
      }
    }
    return instance;
  }
}