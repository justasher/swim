// observer.dart

import 'package:flutter/material.dart';
import 'package:swim/src/pool.dart';
import 'package:swim/src/provider.dart';

class Swim<T extends Pool> extends StatefulWidget {
  final String? id;
  final Widget Function(BuildContext context) builder;

  const Swim({
    Key? key,
    this.id,
    required this.builder,
  }) : super(key: key);

  @override
  SwimState<T> createState() => SwimState<T>();
}

class SwimState<T extends Pool> extends State<Swim<T>> {
  late T pool;

  @override
  void initState() {
    super.initState();
    pool = Provider.getAndCreateIfNull<T>(id: widget.id);
    pool.addListener(_listener);
    Provider.registerObserver<T>(pool.hashCode);
  }

  @override
  void dispose() {
    pool.removeListener(_listener);
    Provider.unregisterObserver<T>(pool.hashCode);
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