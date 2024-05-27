mixin LifeCycleMixin {
  bool _initialized = false;
  bool _isClosed = false;

  void onInit() {
    // Override this method in your controller to provide initialization logic
  }

  void onClose() {
    // Override this method in your controller to provide cleanup logic
  }

  // Make these methods protected instead of private
  void initialize() {
    if (_initialized) return;
    onInit();
    _initialized = true;
  }

  void dispose() {
    if (_isClosed) return;
    onClose();
    _isClosed = true;
  }
}
