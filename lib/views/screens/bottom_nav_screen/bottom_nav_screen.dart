import 'package:flutter/material.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_images.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/views/components/bottom-nav-screen/navbar_items.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/home/home_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/loan_screen/loan_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/my_loan_screen/my_loan_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/menu/menu_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    LoanScreen(),
    MyLoanScreen(),
    MenuScreen(),
  ];

  final List<String> _titles = [
    MyStrings.home,
    MyStrings.takeloan,
    MyStrings.myLoan,
    MyStrings.menu,
  ];

  final List<String> _img = [
    MyImages.homeIcon,
    MyImages.loanIcon,
    MyImages.transactionIcon,
    MyImages.menuIcon,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: MyColor.colorWhite,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(25, 0, 0, 0),
                  offset: Offset(-2, -2),
                  blurRadius: 2
                )
              ],
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => NavBarItem(
                    key: Key(index.toString()),
                    label: _titles[index],
                    imagePath: _img[index],
                    index: 3,
                    isSelected: _currentIndex == index,
                    press: () {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                )),
          ),
        )
        );
  }
}
