import 'package:flutter/material.dart';

class ReverseListView extends StatefulWidget {
  final List<Widget> children;
  final ScrollController controller;

  ReverseListView({required this.children, required this.controller});

  @override
  _ReverseListViewState createState() => _ReverseListViewState();
}

class _ReverseListViewState extends State<ReverseListView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.controller,
      reverse: true, // Reverse the ListView
      children: widget.children,
    );
  }
}
