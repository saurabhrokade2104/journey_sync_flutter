import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String content;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  const TextWidget(
      {super.key,
      required this.content,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: 'SourceSans3',

        color: color,
      ),
    );
  }
}
