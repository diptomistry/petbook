import 'package:petbook/common/extension/custon_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:petbook/common/modelss/user_model.dart';

class YellowCard extends StatelessWidget {
  const YellowCard({
    Key? key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'hey...wanna ask something about pet??',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
  }
}
