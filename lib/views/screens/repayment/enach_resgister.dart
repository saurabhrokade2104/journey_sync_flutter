// ignore_for_file: camel_case_types
import 'package:finovelapp/core/route/route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class eNachRegisterScreen extends StatefulWidget {
  const eNachRegisterScreen({super.key});

  @override
  State<eNachRegisterScreen> createState() => _eNachRegisterScreenState();
}

class _eNachRegisterScreenState extends State<eNachRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
            const Text(
              'Back',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: Column(

        children: [
          Container(
            padding: const EdgeInsets.only(left: 30,top: 7),
            height: size.height * 0.08,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: const Text(
              'Final Step Remaining',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              height: size.height * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 2,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Register eNach',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    'Credit on Finovel Paylater',
                    style: TextStyle(
                        color: Color.fromARGB(255, 130, 128, 128),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.4),
                    thickness: 2,
                  ),
                  const Text(
                    'Link your Debit Card/Net Banking of your HDFC Bank A/c (xxx7403) now. Keep your Debit Card/Net Banking login ready !',
                    style: TextStyle(
                        color: Color.fromARGB(255, 130, 128, 128),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          //
          //
          //  Image Section Here
          //

          SizedBox(
            height: size.height * 0.3,
            width: size.width,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/reward_points.png'),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    height: size.height * 0.2,
                    width: size.width * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Image.asset('assets/images/reward_points2.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //
          //
          //Image section ends here
          //

          const Spacer(),
          GestureDetector(
            onTap: () {
              if (kDebugMode) {
                print('Clicked On DO IT LATER');
              }
              Get.offAndToNamed(RouteHelper.loanSuccessScreen);
            },
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DO IT LATER',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_right,
                  size: 35,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          Container(
            height: size.height * 0.07,
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: TextButton(
                onPressed: () {
                  if (kDebugMode) {
                    print('Clicked On REGISTER NOW BUTTON');
                  }
                },
                child: const Center(
                  child: Text(
                    'REGISTER NOW   ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
