import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news/constants.dart';
import 'package:news/screens/home/components/sidebar_container.dart';

class Categories extends StatefulWidget {
  const Categories({
    Key key,
  }) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final Stream<QuerySnapshot> posts =
      FirebaseFirestore.instance.collection("posts").snapshots();

  @override
  Widget build(BuildContext context) {
    return SidebarContainer(
      title: "Categories",
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            final arrayFiltered =
                data.docs.map((e) => e['category']).toSet().toList();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: arrayFiltered.length,
              itemBuilder: (context, index) {
                return Category(
                  title: data.docs[index]['category'],
                  press: () {},
                  numOfItems: data.docs
                      .map((e) => e['category'])
                      .where((element) => element == arrayFiltered[index])
                      .length,
                );
              },
            );
          },
        )
      ]),
    );
  }
}

class Category extends StatelessWidget {
  final String title;
  final int numOfItems;
  final VoidCallback press;
  const Category({
    Key key,
    @required this.title,
    @required this.numOfItems,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
      child: TextButton(
        onPressed: press,
        child: Text.rich(
          TextSpan(
            text: title,
            style: TextStyle(color: kDarkBlackColor),
            children: [
              TextSpan(
                text: ' ($numOfItems)',
                style: TextStyle(color: kBodyTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
