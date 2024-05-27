import 'package:swim/src/listerner.dart';
import 'lifecycle.dart';


abstract class Pool with LifeCycleMixin, ListNotifier {

  void update([String? id]) {
    notifyListeners(id);
  }
}