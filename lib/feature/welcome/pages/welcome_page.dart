import 'package:flutter/material.dart';
import 'package:petbook/common/routes/routes.dart';
import 'package:petbook/common/widgets/custom_elevated_button.dart';
import '../../auth/pages/login_page.dart';
import '../widgets/language_button.dart';
import '../widgets/privacy_and_terms.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key});

  void navigateToLoginPage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.login,
          (route) => true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                ),
                child: Image.asset(
                  'assets/circle.png',
                  color: Colors.lightBlue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Welcome to Chatpet',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //const PrivacyAndTerms(),
                CustomElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>LoginPage())
                    );
                  },
                  text: 'AGREE AND CONTINUE',
                ),
                const SizedBox(height: 50),
                //const LanguageButton(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
