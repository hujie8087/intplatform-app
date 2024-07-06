import 'package:flutter/material.dart';

class FilmDanmaku extends StatelessWidget {
  final String text;
  final double top;

  FilmDanmaku({required this.text, required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: MediaQuery.of(context).size.width,
      child: TweenAnimationBuilder(
        tween: Tween<Offset>(begin: Offset(1, 0), end: Offset(-1, 0)),
        duration: Duration(seconds: 5),
        builder: (context, Offset offset, child) {
          return FractionalTranslation(
            translation: offset,
            child: child,
          );
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16, shadows: [
            Shadow(blurRadius: 4, color: Colors.black),
          ]),
        ),
      ),
    );
  }
}
