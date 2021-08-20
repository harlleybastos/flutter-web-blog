import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news/constants.dart';
import 'package:news/controllers/MenuController.dart';
import 'package:news/responsive.dart';
import 'package:news/screens/main/components/socal.dart';
import 'package:news/screens/main/components/web_menu.dart';

class Header extends StatelessWidget {
  final MenuController _controller = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: kDarkBlackColor,
      child: SafeArea(
        child: Container(
          constraints: BoxConstraints(maxWidth: kMaxWidth),
          padding: EdgeInsets.all(kDefaultPadding),
          child: Column(children: [
            Row(
              children: [
                if (!Responsive.isDesktop(context))
                  IconButton(
                    onPressed: () {
                      _controller.openOrCloseDrawer();
                    },
                    icon: Icon(Icons.menu, color: Colors.white),
                  ),
                SvgPicture.asset(
                  "assets/icons/logo.svg",
                  width: 60,
                  height: 60,
                ),
                Spacer(),
                if (Responsive.isDesktop(context)) WebMenu(),
                Spacer(),
                Socal(),
              ],
            ),
            SizedBox(height: kDefaultPadding * 2),
            Text("Bem vindo ao Sons of Harllão",
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              child: Text("O melhor de Sons of Anarchy é com o Harllão !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Raleway', height: 1.5)),
            ),
            FittedBox(
              child: TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        "Leia Mais",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(width: kDefaultPadding / 2),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  )),
            ),
            SizedBox(height: kDefaultPadding),
          ]),
        ),
      ),
    );
  }
}
