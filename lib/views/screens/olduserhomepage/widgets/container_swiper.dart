import 'package:card_swiper/card_swiper.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/views/screens/olduserhomepage/widgets/text_widget.dart';
import 'package:flutter/material.dart';

Widget cardSwiper(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SizedBox(
      height: size.height * 0.25,
      width: double.infinity,
      child: Swiper(
          autoplay: true,
          autoplayDelay: 2000,
          pagination: const SwiperPagination(
            alignment: Alignment.bottomCenter,
            builder: DotSwiperPaginationBuilder(
              color: Colors.grey,
              activeColor: MyColor.primaryColor,
            ),
          ),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) => Container(
                decoration: BoxDecoration(
                    // color: Colors.limeAccent,
                    borderRadius: BorderRadius.circular(15)),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: MyColor.primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  content: 'Load on Salary',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                TextWidget(
                                  content: 'In 15 minutes',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                TextWidget(
                                  content:
                                      'To withdraw and get more Loan \n amount complete your KYC',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            Container(
                              width: size.width * 0.4,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/icons/money_bag_icon.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: size.width * 0.45,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: const Center(
                          child: TextWidget(
                            content: 'GET UP TO ₹50,000',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
    ),
  );
}
