import 'package:flutter/widgets.dart';

typedef VoidCallbackWithId = void Function(String?);

typedef ValueUpdater<T> = T Function();

WidgetsBinding get engine {
  return WidgetsFlutterBinding.ensureInitialized();
}