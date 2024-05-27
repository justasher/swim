import 'package:swim/src/listerner.dart';
import 'lifecycle.dart';


abstract class Pool with LifeCycleMixin, ListNotifier {
  Pool() {
    initialize();  // Ensure initialization logic is called
  }

  void update([String? id]) {
    notifyListeners(id);
  }

  @override
  void dispose() {
    dispose();  // Ensure disposal logic is called
  }
}
class MyPool extends Pool {}

void main() {
  Pool myPool = MyPool();


}