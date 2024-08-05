import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final Color color;
  final Color? borderColor;
  final double fontSize;

  const StrokeText(
    this.text, {
    this.color = Colors.pink,
    this.borderColor = const Color.fromRGBO(255, 255, 255, 1),
    this.fontSize = 16,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return borderColor == null
        ? Text(
            text,
            style: TextStyle(fontSize: fontSize, color: color),
          )
        : Stack(
            children: <Widget>[
              Text(
                text,
                softWrap: false,
                style: TextStyle(
                  fontSize: fontSize,
                  overflow: TextOverflow.visible,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..strokeCap = StrokeCap.round
                    ..strokeJoin = StrokeJoin.round
                    ..color = borderColor!,
                ),
              ),
              Text(
                text,
                softWrap: false,
                style: TextStyle(
                  fontSize: fontSize,
                  color: color,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          );
  }
}
