import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petbook/health/health_tips_details.dart';

class HealthTip {
  final String id; // Document ID
  final String title;
  final String content;
  final String image;
  final List<String> likes; // List of user IDs who liked the tip
  int totalLikes; // Total count of likes

  HealthTip({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.likes,
    this.totalLikes = 0,
  });
}

class HealthTipCard extends StatelessWidget {
  final String title;
  final String content;
  final String imagePath;
  final HealthTip tip; // Path to your image asset

  HealthTipCard(
      {required this.title,
      required this.content,
      required this.imagePath,
      required this.tip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(HealthTipDetailsPage(
            title: title, content: content, imagePath: imagePath, id: tip.id));
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.28,
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                          maxLines: 5,
                          text: TextSpan(
                            text: content,
                            style: TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black),
                          )),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Color(0xFF00a19d),
                          ),
                          Text(
                            ' ${tip.likes.length} people loves',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: Colors.black),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imagePath,
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.2,
                      fit: BoxFit.fill, // Adjust the width as needed
                    ),
                  ),
                ), // Add spacing between text and image
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HealthTipsPage extends StatelessWidget {
  Future<List<HealthTip>> fetchHealthTips() async {
    final QuerySnapshot tipSnapshot =
        await FirebaseFirestore.instance.collection('tips').get();
    final List<HealthTip> tips = [];

    for (QueryDocumentSnapshot tipDocument in tipSnapshot.docs) {
      final List<dynamic> likes = tipDocument['likes'];
      final int totalLikes = likes.length;

      tips.add(HealthTip(
        id: tipDocument.id,
        title: tipDocument['title'],
        content: tipDocument['content'],
        image: tipDocument['image'],
        likes: likes.cast<String>(),
        totalLikes: totalLikes,
      ));
    }

    return tips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Pet Health Tips'),
        elevation: 0,
        // Customize the color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: fetchHealthTips(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    var tips = snapshot.data;

                    return Flexible(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: tips?.length,
                          itemBuilder: (context, index) {
                            var tip = tips![index];
                            return HealthTipCard(
                                title: '${tip.title}',
                                content: tip.content,
                                imagePath: tip.image,
                                tip: tip);
                          }),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
