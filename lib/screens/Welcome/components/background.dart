import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    required Key key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/9.png",
                height: size.height * 0.18,
              )),
          Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/images/2.png",
                height: size.height * 0.18,
              )),
          Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/4.png",
                height: size.height * 0.2,
              )),
          Positioned(
              left: 0,
              right: -290,
              child: Image.asset(
                "assets/images/10.png",
                height: size.height * 0.2,
              )),
          Positioned(
              top: 80,
              right: 0,
              child: Image.asset(
                "assets/images/12.png",
                height: size.height * 0.1,
              )),
          Positioned(
              bottom: 450,
              left: 0,
              child: Image.asset(
                "assets/images/11.png",
                height: size.height * 0.1,
              )),
          Positioned(
              top: -50,
              right: -40,
              child: Image.asset(
                "assets/images/3.png",
                height: size.height * 0.13,
              )),
          child,
        ],
      ),
    );
  }
}
