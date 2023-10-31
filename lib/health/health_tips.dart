import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HealthTipCard extends StatelessWidget {
  final String title;
  final String content;
  final String imagePath; // Path to your image asset

  HealthTipCard({
    required this.title,
    required this.content,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
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
                          maxLines: 3,
                          text: TextSpan(
                            text: content,
                            style: TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black),
                          ))
                    ],
                  ),
                ),
                SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imagePath,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.38,
                    fit: BoxFit.cover, // Adjust the width as needed
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HealthTipCard(
                title: '1. Regular Exams are Vital',
                content:
                    'Just like you, your pet can get heart problems, develop arthritis, or have a toothache. The best way to prevent such problems or catch them early is to see your veterinarian every year. Regular exams are the single most important way to keep pets healthy. Annual vet visits should touch on nutrition and weight control, as well as cover recommended vaccinations, parasite control, dental exam, and health screenings.',
                imagePath:
                    'https://d2zp5xs5cp8zlg.cloudfront.net/image-44386-800.jpg',
              ),
              HealthTipCard(
                title: '2. Spay and Neuter Your Pets',
                content:
                    'Eight million to 10 million pets end up in U.S. shelters every year. Some are lost, some have been abandoned, and some are homeless. Here’s an easy way to avoid adding to that number — spay and neuter your cats and dogs. It’s a procedure that can be performed as early as six to eight weeks of age. Spaying and neutering doesn’t just cut down on the number of unwanted pets; it has other substantial benefits for your pet. Studies show it also lowers the risk of certain cancers and reduces a pet’s risk of getting lost by decreasing the tendency to roam.',
                imagePath:
                    'https://vetncare.com/wp-content/uploads/2014/02/esterilizacion-temprana_4_1483679.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
