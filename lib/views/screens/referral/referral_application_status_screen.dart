import 'package:finovelapp/views/components/appbar/custom_appbar_view.dart';
import 'package:flutter/material.dart';

class ReferralApplicationStatusScreen extends StatelessWidget {
  const ReferralApplicationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
             CustomAppBarView(
              title: 'Application Status',
              onBackPress: () {
                Navigator.pop(context);
              },
            ),
            // SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50,),
                  const Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Text(
                        "Sorry, You're on the waitlist!",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/application_status.png', // Replace with your SVG image path
                    height: 250,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Application Status Still Pending',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sorry for the inconvenience you are on the waiting list, thank you for your patience we will contact you shortly.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Handle back button press
                  //   },
                  //   child: const Text('BACK'),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
