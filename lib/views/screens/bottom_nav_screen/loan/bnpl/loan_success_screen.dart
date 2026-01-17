import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanSuccessScreen extends StatelessWidget {
  const LoanSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: AppColors
                .accentColor, // Replace with your AppColors.accentColor
            child: Image.asset('assets/images/status_bg.png',
                fit: BoxFit.cover), // Your background image
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/imgs/kyc.png',
                height: 150,
              ),
              const SizedBox(height: 24),
              const Text(
                'Loan Application Successfully Submitted',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48.0),
                child: Text(
                  "Thank you for submitting your loan application! It's currently being processed in our system. Please sit tight; we'll get back to you with a response shortly.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.only(top: 100),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white), // White border color
                  borderRadius: BorderRadius.circular(4.0), // Border radius
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(RouteHelper.homeScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text('GO TO HOME'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
