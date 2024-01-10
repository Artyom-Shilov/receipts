import 'package:flutter/material.dart';

class Bookmark extends StatelessWidget {
  const Bookmark(
      {Key? key,
      required this.color,
      required this.number,
      required this.height,
      required this.width})
      : super(key: key);

  final double height;
  final double width;
  final Color color;
  final int number;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BookmarkClipper(),
      child: Container(
        height: height,
        width: width,
        color: color,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(width / 20, 0, width / 10, 0),
            child: Text(
              number.toString(),
              maxLines: 1,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BookmarkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..lineTo(size.width / 3, size.height / 2)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
