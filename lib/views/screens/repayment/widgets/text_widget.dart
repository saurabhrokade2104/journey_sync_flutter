import 'package:flutter/material.dart';

Widget leftRightText({required String leftText, required String rightText}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: const TextStyle(
              color: Color.fromARGB(255, 130, 128, 128),
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        Text(
          rightText,
          style: const TextStyle(
              color: Color.fromARGB(255, 5, 5, 5),
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
