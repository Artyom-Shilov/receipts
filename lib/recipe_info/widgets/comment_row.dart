import 'package:flutter/material.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/models/comment.dart';

class CommentRow extends StatelessWidget {
  final Comment comment;

  const CommentRow({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 2,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: comment.user.avatar == null
                  ? const AssetImage('assets/avatars/empty_avatar.jpg')
                  : Image.memory(comment.user.avatar!).image,
            )),
        const Spacer(flex: 1),
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    comment.user.login,
                    style: const TextStyle(color: AppColors.accent),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    comment.datetime,
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
              const SizedBox(height: 12),
              Text(comment.text),
              const SizedBox(height: 12),
              if (comment.photo != null)
                Image.memory(comment.photo!,
                  height: MediaQuery.of(context).size.longestSide * 0.15),
              const SizedBox(height: Insets.vertical1),
            ],
          ),
        )
      ],
    );
  }
}
