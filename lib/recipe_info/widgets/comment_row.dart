import 'package:flutter/material.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/constants/size_break_points.dart';
import 'package:receipts/common/models/comment.dart';

class CommentRow extends StatelessWidget {
  final Comment comment;

  const CommentRow({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>  SizedBox(
        height: constraints.maxWidth < SizeBreakPoints.phoneLandscape
            ? MediaQuery.of(context).size.longestSide * 0.25
            : MediaQuery.of(context).size.longestSide * 0.50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: CircleAvatar(
                  radius: 30,
                  child: Image.asset(comment.user!.avatar),
                )),
            const Spacer(flex: 1,),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comment.user?.login ?? '',
                        style: const TextStyle(color: AppColors.accent),
                      ),
                      Text(comment.datetime, style: const TextStyle(color: Colors.grey),)
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(comment.text),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(child: Image.asset(comment.photo, fit: BoxFit.fill,)),
                  const SizedBox(
                    height: Insets.vertical1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}