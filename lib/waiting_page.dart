import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petbook/auth/homepage.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/intro.png',
                ),
                fit: BoxFit.fill)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Team: Three Pack',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 30),
              TeamMemberCard(
                name: 'Md. Rasel Hossen',
                role: '39',
                image: 'assets/rasel.jpg', // Replace with image asset path
              ),
              TeamMemberCard(
                name: 'Diptajoy Mistry',
                role: '34',
                image: 'assets/dipto.jpg', // Replace with image asset path
              ),
              TeamMemberCard(
                name: 'Mushiur Mukul',
                role: '58',
                image: 'assets/mukul.jpeg', // Replace with image asset path
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Get.off(() => HomePage(setThemeMode: (ThemeMode) {}));
                },
                child: Container(
                  height: 50,
                  width: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.brown),
                  child: Center(
                      child: Text(
                    'Enter',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String image;

  TeamMemberCard({
    required this.name,
    required this.role,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(image),
          radius: 30,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(role),
      ),
    );
  }
}
