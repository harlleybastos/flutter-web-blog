import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news/constants.dart';
import 'package:news/responsive.dart';
import 'package:news/screens/home/components/blog_post.dart';
import 'package:news/screens/home/components/categories.dart';
import 'package:news/screens/home/components/recent_posts.dart';
import 'package:news/screens/home/components/search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> posts =
      FirebaseFirestore.instance.collection("posts").snapshots();
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: posts,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong.");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator());
                      }
                      final data = snapshot.requireData;

                      return ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          return PostCardBlog(
                            description: data.docs[index]['description'],
                            title: data.docs[index]['title'],
                            imgUrl: data.docs[index]['imgUrl'],
                            date: data.docs[index]['date'],
                            category: data.docs[index]['category'],
                          );
                        },
                      );
                    },
                  ))
            ],
          ),
        ),
        if (!Responsive.isMobile(context)) SizedBox(width: kDefaultPadding),
        //Sidebar
        if (!Responsive.isMobile(context))
          Expanded(
            child: Column(
              children: [
                Search(),
                SizedBox(height: kDefaultPadding),
                Categories(),
                SizedBox(height: kDefaultPadding),
                RecentPosts(),
              ],
            ),
          )
      ],
    );
  }
}
