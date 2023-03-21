import 'dart:convert';
import 'package:channabf/functions.dart';
import 'package:http/http.dart' as http;

Future<void> signup(String phoneNumber, String email, String password) async {
  String csrfToken = await getCsrfToken();

  final response = await http.post(
    Uri.parse('http://10.30.0.76:8000/account/api/signup/'),
    headers: {
      'Content-Type': 'application/json',
      'X-CSRFToken': csrfToken,
    },
    body: jsonEncode({
      'phone_number': phoneNumber,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode != 200) {
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to signup');
  }
}
