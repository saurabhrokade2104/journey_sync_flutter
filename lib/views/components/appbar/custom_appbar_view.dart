import 'package:flutter/material.dart';

class CustomAppBarView extends StatelessWidget {
  final String title;
  final VoidCallback onBackPress;

  const CustomAppBarView({super.key, required this.title, required this.onBackPress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/imgs/header_bg.png', // Replace with your background image path
          fit: BoxFit.cover,
          width: double.infinity,
          height: 150,
        ),


        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 85),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBackPress,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}