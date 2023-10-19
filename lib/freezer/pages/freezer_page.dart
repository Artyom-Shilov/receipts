import 'package:flutter/material.dart';
import 'package:receipts/common/constants/app_texts.dart';

class FreezerPage extends StatelessWidget {
  const FreezerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(StabTexts.workInProgress),
    );
  }
}
