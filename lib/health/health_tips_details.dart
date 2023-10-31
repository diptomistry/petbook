import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthTipDetailsPage extends StatelessWidget {
  final String title;
  final String content;
  final String imagePath;
  final id;
  HealthTipDetailsPage(
      {required this.title,
      required this.content,
      required this.imagePath,
      required this.id});
  RxBool tap = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Health Tip Details'),
        // Customize the color
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: MediaQuery.of(context).size.height * 0.5,
            right: 0,
            left: 0,
            child: Container(
              child: Image.network(
                imagePath,
                fit: BoxFit.fill,
              ), // Replace with your image asset
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      30), // Adds a curve to the top-left corner
                  topRight: Radius.circular(30),
                ),
                color: Color(0xFFFFF9C4),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      Obx(() {
                        return IconButton(
                          onPressed: () {
                            tap.toggle();
                            // Handle love button tap
                          },
                          icon: Icon(
                            tap.value ? Icons.favorite : Icons.favorite_border,
                            color: tap.value ? Color(0xFF00a19d) : Colors.black,
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    content,
                    style: TextStyle(
                        fontSize: 16, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
