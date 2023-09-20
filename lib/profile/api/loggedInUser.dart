import 'dart:convert';
import 'package:http/http.dart' as http;

class LoggedInUser {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final int userType;
  final String? userSettings;
  final String? dob;
  final String phone;
  final String? profileImage;
  final String points;
  final int eventId;

  LoggedInUser({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.userType,
    required this.userSettings,
    required this.dob,
    required this.phone,
    required this.profileImage,
    required this.points,
    required this.eventId,
  });

  factory LoggedInUser.fromJson(Map<String, dynamic> json) {
    return LoggedInUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userType: json['user_type'],
      userSettings: json['user_settings'],
      dob: json['dob'],
      phone: json['phone'],
      profileImage: json['profile_image'],
      points: json['points'],
      eventId: json['event_id'],
    );
  }
}

Future<LoggedInUser?> fetchLoggedInUser() async {
  final apiUrl =
      'https://tickets-mascon.madwartech.com/api/user/me'; // Replace with your API endpoint
  //String? token = await SharedPreferencesHelper.getToken();

  // final response = await http.post(
  //   Uri.parse(apiUrl),
  //   headers: {
  //     'Authorization': 'Bearer $token', // Add your token here
  //     'Content-Type': 'application/json',
  //   },
  // );

  // if (response.statusCode == 200) {
  //   final jsonData = json.decode(response.body);
  //   return LoggedInUser.fromJson(jsonData['data']['user']);
  // } else {
  //   throw Exception('Failed to load user data');
  // }
}
