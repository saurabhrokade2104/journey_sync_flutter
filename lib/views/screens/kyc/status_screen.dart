
import 'package:flutter/material.dart';

import '../../../core/utils/colors.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: double.infinity,
            width: double.infinity,
            color: AppColors.accentColor,
            child: Image.asset('assets/images/status_bg.png')),
        Center(
            child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Image.asset('assets/images/success.png'),
        )),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Center(
                child: TextButton(
                    onPressed: () => {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => const LoanStepScreen())),
                          //   Navigator.of(context).push(MaterialPageRoute(
                          // builder: (context) => const CreditScreen())),
                        },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(
                        //   'GET A LOAN',
                        //   style: TextStyle(
                        //       color: AppColors.whiteColor,
                        //       fontWeight: FontWeight.w600),
                        // ),
                        SizedBox(
                          width: 2,
                        ),
                        // Icon(
                        //   Icons.arrow_forward_ios,
                        //   size: 14,
                        //   color: AppColors.whiteColor,
                        // )
                      ],
                    ))),
          ),
        )
      ],
    );
  }
}
