import 'package:flutter/material.dart';
import 'package:receipts/common/constants/constants.dart';


class RecipeInfoSectionTitle extends StatelessWidget {
  const RecipeInfoSectionTitle({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: Insets.vertical1),
    required this.text
  });

  final EdgeInsets padding;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.main),
      ),
    );
  }
}
