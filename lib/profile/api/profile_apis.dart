import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

// import '../../login/sharedPRef.dart';

Future<String> updateUserWithImage({
  String? name,
  String? email,
  String? phone,
  String? oldPassword,
  String? newPassword,
  File? profileImage,
}) async {
  final uri =
      Uri.parse('https://tickets-mascon.madwartech.com/api/update-user');

  // Create a multipart request
  final request = http.MultipartRequest("POST", uri);

  // Add the form fields
  if (name != null) {
    request.fields['name'] = name;
  }
  if (email != null) {
    request.fields['email'] = email;
  }
  if (phone != null) {
    request.fields['phone'] = phone;
  }
  if (oldPassword != null) {
    request.fields['old_password'] = oldPassword;
  }
  if (newPassword != null) {
    request.fields['new_password'] = newPassword;
  }

  // Add the profile image if provided
  if (profileImage != null) {
    final stream =
        http.ByteStream(DelegatingStream.typed(profileImage.openRead()));
    final length = await profileImage.length();
    final filename = basename(profileImage.path);

    final multipartFile =
        http.MultipartFile('file', stream, length, filename: filename);
    request.files.add(multipartFile);
  }
  String? token = 'dsd';
  request.headers['Authorization'] =
      'Bearer $token'; // Replace 'Bearer' with your token type if needed
  try {
    // Send the request
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();

      return json.decode(responseData)['message'] ??
          'Updated Successfully'; // Return success message
    } else {
      final errorData = await response.stream.bytesToString();
      final errorMessage = json.decode(errorData)['message'];
      if (json.decode(errorData)['error'].toInt() == 0)
        return 'Updated Successfully';
      print(json.decode(errorData));
      return errorMessage; // Return error message
    }
  } catch (e) {
    print('Error: $e');
    return 'An error occurred'; // Return a generic error message
  }
}
