import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailController = TextEditingController();
  bool _isResetting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future _resetPassword() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text('Password reset link sent.Check your email.'),
        );
      },
      );
    } on FirebaseAuthException catch(e) {
      print(e);
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      },
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Petbook',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:Color(0xFFA1887F),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 86.0, 16.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/reset.png', // Replace this with your app logo
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 16),
                Text(
                  'Enter your email and we will send you a password reset link',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 44),
                ElevatedButton(
                  onPressed: _isResetting ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA1887F),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isResetting
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,

                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
