import 'package:flutter/material.dart';
import 'package:receipts/common/constants/insets.dart';

class BleMessage extends StatelessWidget {
  const BleMessage({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.horizontal1),
      child: Text(text, style: const TextStyle(color: Colors.red, fontSize: 14)),
    );
  }
}
