// ignore_for_file: library_private_types_in_public_api


import 'package:finovelapp/views/screens/kyc/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

import '../../../core/utils/colors.dart';



class KycScreenV2 extends StatefulWidget {
  const KycScreenV2({super.key});

  @override
  State<KycScreenV2> createState() => _KycScreenV2State();
}

int currentStep = 1;

class _KycScreenV2State extends State<KycScreenV2> {
  bool isMale = false;
  bool isMarried = true;
  void toggleWidget() {
    setState(() {
      currentStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Stack(children: [
        Image.asset('assets/images/header_bg.png',
            fit: BoxFit.fill, width: double.infinity, height: 210),
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 40),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 15,
                color: AppColors.whiteColor,
              ),
              Text(
                'BACK',
                style: TextStyle(
                    color: AppColors.whiteColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Align(
            alignment: FractionalOffset.bottomCenter,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor),
                onPressed: toggleWidget,
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: currentStep == 1
                      ? const Center(
                          child: Text(
                            'ADD DETAILS',
                            style: TextStyle(color: AppColors.whiteColor),
                          ),
                        )
                      : currentStep == 2
                          ? const Center(
                              child: Text('GET OTP',
                                  style:
                                      TextStyle(color: AppColors.whiteColor)),
                            )
                          : InkWell(
                              onTap: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const StatusScreen())),
                              },
                              child: const Center(
                                child: Text('VERIFY',
                                    style:
                                        TextStyle(color: AppColors.whiteColor)),
                              ),
                            ),
                ))),
        Padding(
          padding: const EdgeInsets.only(top: 70.0, right: 10, left: 15),
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Get your profile verify in 3 Steps',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                  color: currentStep >= 1
                                      ? AppColors.whiteColor
                                      : AppColors.progressFaintColor),
                              child: InkWell(
                                onTap: () => {currentStep = 1, setState(() {})},
                                child: const Center(
                                    child: Text(
                                  '1',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accentColor),
                                )),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(5),
                              height: 5,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: currentStep > 1
                                      ? AppColors.whiteColor
                                      : AppColors.progressFaintColor),
                            ),
                            Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                  color: currentStep >= 2
                                      ? AppColors.whiteColor
                                      : AppColors.progressFaintColor),
                              child: InkWell(
                                onTap: () => {currentStep = 2, setState(() {})},
                                child: const Center(
                                    child: Text(
                                  '2',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accentColor),
                                )),
                              ),
                            ),
                            Container(
                              height: 5,
                              margin: const EdgeInsets.all(5),
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: currentStep >= 3
                                      ? AppColors.whiteColor
                                      : AppColors.progressFaintColor),
                            ),
                            Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                  color: currentStep >= 3
                                      ? AppColors.whiteColor
                                      : AppColors.progressFaintColor),
                              child: InkWell(
                                onTap: () => {currentStep = 3, setState(() {})},
                                child: const Center(
                                    child: Text(
                                  '3',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accentColor),
                                )),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              const Padding(
                padding: EdgeInsets.only(top: 86.0, right: 5, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 2,
                        child: Text('Add Personal Details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.whiteColor, fontSize: 11))),
                    Spacer(),
                    Flexible(
                        flex: 2,
                        child: Text('Upload Selfie & Capture ID Proof',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.whiteColor, fontSize: 11))),
                    Spacer(),
                    Flexible(
                      flex: 2,
                      child: Text(
                        'Get OTP & Verify Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.whiteColor, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              (currentStep == 1)
                  ? Padding(

                     padding:const EdgeInsets.only(top:150,bottom:60),
                    child: SingleChildScrollView(
                      child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, right: 10, left: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fill Details',
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10,
                                  ),
                                  child: TextField(
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText: 'Full Name',
                                        hintText: 'Full Name'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextField(
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          //DateTime.now() - not to allow to choose before today.
                                          lastDate: DateTime(2100));

                                      if (pickedDate != null) {
                                        //pickedDate output format => 2021-03-10 00:00:00.000

                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        //formatted date output using intl package =>  2021-03-16
                                        setState(() {
                                          // dateInput.text =
                                          //     formattedDate; //set output date to TextField value.
                                        });
                                      } else {}
                                    },
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                        suffixIcon: Icon(Icons.calendar_month),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6))),
                                        labelText: 'Date of Birth',
                                        hintText: 'Date of Birth'),
                                  ),
                                ),
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 0.0, top: 8),
                                      child: Text(
                                        'Gender',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: InkWell(
                                        onTap: () => {
                                          isMale = true,
                                          setState(() {}),
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          decoration: BoxDecoration(
                                              color: isMale
                                                  ? AppColors.cardFillColor
                                                  : AppColors.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: isMale
                                                      ? AppColors.accentColor
                                                      : const Color.fromARGB(
                                                          255, 169, 166, 166))),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 18,
                                                  width: 18,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      border: Border.all(
                                                          color: AppColors
                                                              .blackColor)),
                                                  child: Center(
                                                    child: isMale
                                                        ? const Icon(
                                                            Icons.circle,
                                                            color: AppColors
                                                                .accentColor,
                                                            size: 16,
                                                          )
                                                        : Container(),
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 12.0,
                                                    bottom: 12,
                                                    left: 0),
                                                child: Text('Male'),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: InkWell(
                                        onTap: () {
                                          isMale = false;
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              color: isMale
                                                  ? AppColors.whiteColor
                                                  : AppColors.cardFillColor,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: isMale
                                                      ? const Color.fromARGB(
                                                          255, 169, 166, 166)
                                                      : AppColors.accentColor)),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 18,
                                                  width: 18,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      border: Border.all(
                                                          color: AppColors
                                                              .blackColor)),
                                                  child: Center(
                                                    child: !isMale
                                                        ? const Icon(
                                                            Icons.circle,
                                                            color: AppColors
                                                                .accentColor,
                                                            size: 16,
                                                          )
                                                        : Container(),
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 12.0,
                                                      bottom: 12,
                                                      left: 0),
                                                  child: Text('Female'))
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10.0, bottom: 10),
                                  child: TextField(
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText: 'Email',
                                        hintText: 'Email'),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10.0, bottom: 10),
                                  child: TextField(
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText: 'Phone Number',
                                        hintText: 'Phone Number'),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10.0, bottom: 10),
                                  child: TextField(
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText: 'Aadhar Number',
                                        hintText: 'Aadhar Number'),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10.0, bottom: 10),
                                  child: TextField(
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText: 'Pan Number',
                                        hintText: 'Pan Number'),
                                  ),
                                ),
                                Row(children: [
                                  Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.greyColor),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(3))),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Agree to ',
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: AppColors.blackColor),
                                  ),
                                  const Text(
                                    'terms & condition.',
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: AppColors.accentColor),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                        ]),
                    ),
                  )
                  : (currentStep == 2)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 150.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CAPTURE SELFIE',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.cardFillColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Image.asset('assets/selfi.png'),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 8,
                                              width: 8,
                                              decoration: BoxDecoration(
                                                  color: AppColors.accentColor,
                                                  borderRadius:
                                                      BorderRadius.circular(3)),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Text(
                                              'Good Lightning onn your face',
                                              style: TextStyle(
                                                color: AppColors.textGray,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 8,
                                              width: 8,
                                              decoration: BoxDecoration(
                                                  color: AppColors.accentColor,
                                                  borderRadius:
                                                      BorderRadius.circular(3)),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Text('No Glasses & Hat')
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    OutlinedButton(
                                        style: ButtonStyle(
                                          side: WidgetStateProperty.all(
                                              const BorderSide(
                                                  color: AppColors
                                                      .accentColor)), // Change the color to your desired color
                                        ),
                                        // style: OutlinedButton.styleFrom(
                                        //     shadowColor: AppColors.primaryColor),
                                        onPressed: () => {},
                                        child: const Text(
                                          'TAKE A SELFIE',
                                          style: TextStyle(
                                              color: AppColors.accentColor,
                                              fontWeight: FontWeight.w600),
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8),
                          child: Wrap(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 158.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'VERIFICATION',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '09.47',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'You Will get OTP on your mobile number +91 7283487639 OTP will be available for 10 min.',
                                      style: TextStyle(fontSize: 13),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/otp.png',
                                        height: 150,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Pinput(
                                      pinputAutovalidateMode:
                                          PinputAutovalidateMode.onSubmit,
                                      showCursor: true,
                                      onCompleted: (pin) => (pin),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                          'Don’t receive the verification details?'),
                                    ),
                                  ),
                                  const Center(
                                      child: Text(
                                    'RESEND OTP',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.accentColor),
                                  )),
                                ],
                              ),
                            ),
                          ]),
                        ),
            ],
          ),
        ),
      ]),
    );
  }
}

// ignore: camel_case_types
class step1 extends StatefulWidget {
  const step1({super.key});

  @override
  _step1State createState() => _step1State();
}

// ignore: camel_case_types
class _step1State extends State<step1> {
  void toggleWidget() {
    setState(() {
      currentStep++;
    });
  }

  @override
  build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CAPTURE SELFIE'),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: AppColors.cardFillColor,
              child: Image.asset('assets/selfi.png'),
            ),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: AppColors.accentColor,
                              borderRadius: BorderRadius.circular(3)),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text('Good Lightning onn your face')
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: AppColors.accentColor,
                              borderRadius: BorderRadius.circular(3)),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text('No Glasses & Hat')
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shadowColor: AppColors.primaryColor),
                    onPressed: () => {},
                    child: const Text(
                      'Take A Selfie',
                      style: TextStyle(color: AppColors.accentColor),
                    ))
              ],
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor),
                onPressed: toggleWidget,
                child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Add Details',
                      style: TextStyle(color: AppColors.whiteColor),
                    )))
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class step2 extends StatefulWidget {
  const step2({super.key});

  @override
  _step2State createState() => _step2State();
}

// ignore: camel_case_types
class _step2State extends State<step1> {
  @override
  build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 108.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(18.0),
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  labelText: 'First Name',
                  hintText: 'First Name'),
            ),
          ),
        ],
      ),
    );
  }
}
