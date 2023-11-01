import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print("**********************************FCM Token: $token");
      // You can save the token to your server to send notifications.
    });

    _firebaseMessaging.subscribeToTopic("your_topic_name"); // Subscribe to a specific topic if needed

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the message when the app is in the foreground
      // Display an in-app notification or update your chat interface
      // You can customize how to show the notification here.
      // For example, show an alert dialog, update your chat view, or use a notification plugin.
      // The 'message' contains information about the notification.
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the message when the app is terminated and launched
      // You can navigate to the chat page with the relevant user when the app is opened.
    });

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // Handle the message when the app is in the background
    // You can perform background tasks or update your chat interface
  }
}
