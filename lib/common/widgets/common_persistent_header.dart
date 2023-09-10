import 'package:flutter/material.dart';

class CommonPersistentHeader extends StatelessWidget {
  const CommonPersistentHeader({Key? key, required this.maxExtent, required this.color})
      : super(key: key);

  final double maxExtent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        delegate: BottomPersistentHeaderDelegate(maxExtent, color));
  }
}

class BottomPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double extent;
  final Color color;

  BottomPersistentHeaderDelegate(this.extent, this.color);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color,
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => 0;
}