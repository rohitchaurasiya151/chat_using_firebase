import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/rohit_profile.png"),
              alignment: Alignment.center),
          shape: BoxShape.circle),
    );
  }
}
