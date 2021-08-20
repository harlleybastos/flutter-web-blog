import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news/constants.dart';
import 'package:news/screens/home/components/sidebar_container.dart';

class RecentPosts extends StatelessWidget {
  const RecentPosts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> posts =
        FirebaseFirestore.instance.collection("posts").snapshots();
    return SidebarContainer(
      title: "Recent Post",
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: posts,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong.");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    width: 40, height: 40, child: CircularProgressIndicator());
              }
              final data = snapshot.requireData;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Expanded(
                    flex: 2,
                    child: RecentPostCard(
                      image: data.docs[index]['imgUrl'],
                      title: data.docs[index]['title'],
                      press: () {},
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}

class RecentPostCard extends StatelessWidget {
  final String image, title;
  final VoidCallback press;
  const RecentPostCard({
    Key key,
    @required this.image,
    @required this.title,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: press,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.network(image, fit: BoxFit.cover),
            ),
            SizedBox(width: kDefaultPadding),
            Expanded(
              flex: 5,
              child: Text(
                title,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Raleway",
                  color: kDarkBlackColor,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: kDefaultPadding * 2)
          ],
        ),
      ),
    );
  }
}
