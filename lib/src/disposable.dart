import 'package:flutter/foundation.dart';
import 'package:swim/src/lifecycle.dart';

abstract class DisposableInterface with LifeCycleMixin {
  /// Called immediately after the widget is allocated in memory.
  /// You might use this to initialize something for the controller.
  @override
  @mustCallSuper
  void onInit() {
    super.onInit();
  }

  /// Called before [onDelete] method. [onClose] might be used to
  /// dispose resources used by the controller. Like closing events,
  /// or streams before the controller is destroyed.
  /// Or dispose objects that can potentially create some memory leaks,
  /// like TextEditingControllers, AnimationControllers.
  /// Might be useful as well to persist some data on disk.
  @override
  void onClose() {
    super.onClose();
  }
}
