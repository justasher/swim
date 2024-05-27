import 'package:flutter/material.dart';
import 'package:swim/src/typedefs.dart';

mixin ListNotifier {
  final List<VoidCallbackWithId> _listeners = [];
  bool _isNotifying = false;

  @protected
  void addListener(VoidCallbackWithId listener) {
    _listeners.add(listener);
  }

  @protected
  void removeListener(VoidCallbackWithId listener) {
    _listeners.remove(listener);
  }

  @protected
  void notifyListeners([String? id]) {
    if (_isNotifying) return;
    _isNotifying = true;
    for (final listener in List<VoidCallbackWithId>.from(_listeners)) {
      listener(id);
    }
    _isNotifying = false;
  }

  @protected
  void clearListeners() {
    _listeners.clear();
  }

  @protected
  // Debounce mechanism
  void notifyListenersDebounced([String? id]) {
    if (_isNotifying) return;
    _isNotifying = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners(id);
    });
  }
}