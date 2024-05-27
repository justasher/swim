import 'package:swim/src/pool.dart';

class Provider {

  static final Map<Type, Map<String?, Pool?>> _pools = {};
  static final Map<Type, Map<int?, bool?>> _poolsState = {};
  static final Map<Type, Map<int, int>> _observers = {};

  static T create<T extends Pool>({required T Function() create, String? id, bool? permanent}) {
    var instance = get<T>(id: id);
    if (instance == null) {
      instance = create();
      _add(id, instance);
      _poolsState[T]?[instance.hashCode] = permanent;
    }
    return instance;
  }

  static void _add(String? id, Pool pool) {
    final type = pool.runtimeType;
    _pools.putIfAbsent(type, () => {});
    _pools[type]![id] = pool;
  }

  static T? get<T extends Pool>({String? id}) {
    return _pools[T]?[id] as T?;
  }

  static List<T> getAll<T extends Pool>() {
    return _pools[T]?.values as List<T>;
  }

  void deleteById<T extends Pool>({required String id}) {
    _pools[T]?.removeWhere((key, value) => key == id);
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

      var pool = _pools[T]?.entries.firstWhere((e) => e.value.hashCode == hashCode).value;
      if (pool != null && _poolsState[T]?[hashCode] != null && !_poolsState[T]![hashCode]!) {
        pool.dispose();
        _pools[T]?.removeWhere((key, value) => value.hashCode == hashCode);
      }
      if (_observers[T]!.isEmpty) {
        _observers.remove(T);
      }
    }
  }
}
