import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fact_model_api_call.dart';

class CatsFact extends StatefulWidget {
  const CatsFact({super.key});

  @override
  State<CatsFact> createState() => _CatsFactState();
}

class _CatsFactState extends State<CatsFact> {
  var facts = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    var lis = await fetchCatFacts();
    setState(() {
      facts = lis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Facts'), // Change the app bar background color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown, Colors.orange], // Add a gradient background
          ),
        ),
        child: ListView.builder(
          itemCount: facts.length,
          itemBuilder: (context, index) {
            CatFact fact = facts[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Vibrant background color
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  fact.text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
