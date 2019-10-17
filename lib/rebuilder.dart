import 'package:flutter/material.dart';

class Rebuilder extends StatefulWidget {

  final Function(BuildContext) builder;

  const Rebuilder({Key key, this.builder}) : super(key: key);

  @override
  RebuilderState createState() => RebuilderState();

  static RebuilderState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<RebuilderState>());
  }
}

class RebuilderState extends State<Rebuilder> {

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }
}