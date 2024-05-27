// observer.dart

import 'package:flutter/material.dart';
import 'package:swim/src/pool.dart';

class Swim<T extends Pool> extends StatefulWidget {
  final T pool;
  final String? id;
  final Widget Function(BuildContext context) builder;

  const Swim({
    Key? key,
    this.id,
    required this.pool,
    required this.builder,
  }) : super(key: key);

  @override
  SwimState<T> createState() => SwimState<T>();
}

class SwimState<T extends Pool> extends State<Swim<T>> {
  @override
  void initState() {
    super.initState();
    widget.pool.addListener(_listener);
    //PoolProvider.registerSwim<T>(widget.pool.hashCode);
    widget.pool.onInit();
  }

  @override
  void dispose() {
    widget.pool.removeListener(_listener);
    //PoolProvider.unregisterSwim<T>(widget.pool.hashCode);
    super.dispose();
  }

  void _listener([String? id]) {
    if (id == widget.id) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
