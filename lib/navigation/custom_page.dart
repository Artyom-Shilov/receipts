import 'package:flutter/cupertino.dart';

enum Transitions { slide, fade, scale }

final Map<Transitions, Widget Function(Animation<double> animation, Widget child)> transitionMap = {
  Transitions.slide: (Animation<double> animation, Widget child) =>
      SlideTransition(
          position: animation.drive(Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          )),
          child: child),
  Transitions.fade: (Animation<double> animation, Widget child) =>
      FadeTransition(opacity: animation, child: child),
  Transitions.scale: (Animation<double> animation, Widget child) =>
      ScaleTransition(scale: animation, child: child)
};

class CustomPage extends Page {
  const CustomPage({required this.child, required this.forward, required this.back});

  final Widget child;
  final Transitions forward;
  final Transitions back;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        settings: this,
        maintainState: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return animation.status == AnimationStatus.forward
              ? transitionMap[forward]!.call(animation, child)
              : transitionMap[back]!.call(animation, child);
        });
  }
}
