import 'package:flutter/material.dart';

class BackNavigationArrow extends StatelessWidget {
  const BackNavigationArrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              await Router.of(context).routerDelegate.popRoute();
            },
          ),
        ));
  }
}
