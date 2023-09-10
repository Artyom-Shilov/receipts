import 'package:flutter/material.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/models/cooking_step.dart';

class CookingStepRow extends StatelessWidget {
  const CookingStepRow({Key? key, required this.step, required this.index})
      : super(key: key);

  final CookingStep step;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.longestSide * 0.13,
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 3,
            child: Center(
                child: Text(
              index.toString(),
              style: const TextStyle(
                  color: Color.fromRGBO(194, 194, 194, 1),
                  fontSize: 40,
                  fontWeight: FontWeight.w900),
            )),
          ),
          Expanded(
              flex: 10,
              child: Text(
                step.description,
                style: const TextStyle(
                    color: AppColors.greyFont,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              )),
          Flexible(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                      side:
                          const BorderSide(width: 2, color: AppColors.greyFont),
                      value: false,
                      onChanged: (value) {}),
                  Text(
                    step.duration,
                    style: const TextStyle(
                        color: AppColors.greyFont,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
