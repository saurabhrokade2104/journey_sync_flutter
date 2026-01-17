import 'dart:math';

import 'package:finovelapp/views/components/customPainters/CustomPainterAnalogMeter.dart';
import 'package:finovelapp/views/components/customPainters/CustomPainterArrowIndicator.dart';
import 'package:finovelapp/views/components/customPainters/CustomPainterBackground.dart';

import 'package:finovelapp/views/screens/bottom_nav_screen/loan/bnpl/loan_apply_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:vector_math/vector_math.dart' as vmath;

import '../../../../../core/utils/colors.dart';
import 'dart:math' as math;

class CreditScreen extends StatefulWidget {
  final String elgibileAmount;
  final int cibilScore;
  final bool showEligibleAmount;

  const CreditScreen(
      {super.key, required this.elgibileAmount, required this.cibilScore, this.showEligibleAmount=true});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {




  @override
  void initState() {
    super.initState();
    // Initialize meterValue with a random value between 750 and 900


  }


  @override
  Widget build(BuildContext context) {
    bool isRejected = widget.elgibileAmount == 'Rejected';
    return Scaffold(
      backgroundColor: AppColors.accentColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                color: AppColors.accentColor,
                child: Image.asset('assets/images/status_bg.png')),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 70),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                      color: AppColors.whiteColor,
                    ),
                    Text(
                      'BACK',
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 108.0),
                  child: Center(
                    child: Text(
                      'Your Credit Score',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                // Center(
                //     child: Padding(
                //   padding: const EdgeInsets.all(28.0),
                //   child: Image.asset('assets/images/credit_img.png'),
                // )),
                const SizedBox(
                  height: 50,
                ),
                // cibilScore(widget.cibilScore),
                SizedBox(
                  height: 235,
                  child: SfRadialGauge(
                      enableLoadingAnimation: true,
                      animationDuration: 4500,
                      axes: <RadialAxis>[
                        RadialAxis(
                            // startAngle: 180,
                            // endAngle: 360,
                            minimum: 300,
                            maximum: 1000,

                            // axisLineStyle: const AxisLineStyle(
                            //   thickness: 0.1,
                            //   color: Colors.white,
                            //   thicknessUnit: GaugeSizeUnit.factor,
                            // ),
                            // annotationsPosition: GaugeElementPosition.outside,


                            axisLabelStyle: const GaugeTextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: 300,
                                endValue: 630,
                                color: Colors.red,
                                startWidth: 10,
                                endWidth: 10,
                              ),
                              GaugeRange(
                                startValue: 630,
                                endValue: 690,
                                color: Colors.orange,
                                startWidth: 10,
                                endWidth: 10,
                              ),
                              GaugeRange(
                                  startValue: 690,
                                  endValue: 729,
                                  color: Colors.yellow,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 720,
                                  endValue: 1000,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value: widget.cibilScore.toDouble(),
                              )
                            ],

                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Text(
                                    '${widget.cibilScore}',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  angle: 90,
                                  positionFactor: 0.5)
                            ])
                      ]),
                ),

                // CreditScoreIndicator(score: 749,),
                if(widget.showEligibleAmount)
                Column(children: [
                  isRejected
                    ? const SizedBox.shrink()
                    : const Center(
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 40.0, right: 10, left: 10),
                          child: Center(
                            child: Text(
                              'As per your credit eligibility you can get below loan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  // child: Image.asset('assets/images/loan_ad.png'),
                  child: isRejected
                      ? const RejectionCard(
                          message:
                              "We're truly sorry to inform you that your loan application has been declined. \n\nRemember, this isn't the end of your journey. We encourage you to check back later as circumstances and eligibility criteria may change.",
                        )
                      : loanAdWidget(widget.elgibileAmount),
                )),
                isRejected
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 7),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          color: AppColors.whiteColor,
                          child: InkWell(
                            onTap: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const LoanApplicationScreen())),
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(12)),
                              height: 50,
                              child: const Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'TAKE A LOAN',
                                    style: TextStyle(
                                        color: AppColors.accentColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                ],
                              )),
                            ),
                          ),
                        ),
                      )
                ],),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget loanAdWidget(String elgibileAmount) {
  return Container(
    padding: const EdgeInsets.only(top: 10, left: 10, bottom: 20),
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EXCLUSIVELY FOR YOU',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        const Divider(
          height: 5,
          thickness: 1,
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UP TO ₹$elgibileAmount INSTANT\nLOAN AMOUNT',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Great credit score\ndeserves great perks',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Image.asset('assets/images/loan_ad_cut.jpg'),
            ),
          ],
        ),
      ],
    ),
  );
}

class RejectionCard extends StatelessWidget {
  final String message;

  const RejectionCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '😔',
            style: TextStyle(fontSize: 48),
          ),
          SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
