import 'package:petbook/common/extension/custon_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowDateCard extends StatelessWidget {
  const ShowDateCard({Key? key, required this.date}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        DateFormat.yMMMd().format(date),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}
