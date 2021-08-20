import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news/constants.dart';
import 'package:news/responsive.dart';
import 'package:news/screens/add_post/add_dart.dart';

class Socal extends StatelessWidget {
  const Socal({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isMobile(context))
          SvgPicture.asset("assets/icons/facebook_logo.svg",
              width: 24, height: 24),
        if (!Responsive.isMobile(context))
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            child: SvgPicture.asset("assets/icons/instagram_logo.svg",
                width: 24, height: 24),
          ),
        if (!Responsive.isMobile(context))
          SvgPicture.asset("assets/icons/youtube_logo.svg",
              width: 24, height: 24),
        SizedBox(width: kDefaultPadding),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPost(),
                ),
              );
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 1.5,
                    vertical: kDefaultPadding)),
            child: Text("Upload a POST !"))
      ],
    );
  }
}
