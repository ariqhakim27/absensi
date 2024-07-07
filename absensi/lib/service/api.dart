import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/model/login.dart';
import 'package:absensi/model/profile.dart';
import 'package:absensi/service/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://backend-pmp.unand.dev';

  Future<Login?> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final authorizationData = responseData['data']['authorization'];
      final loginData = Login.fromJson(authorizationData);

      final profileData = responseData['data']['profile'];
      final userId = profileData['id'];
      await saveUserId(userId);

      return loginData;
    } else {
      print('Failed to login: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Exception occurred: $e');
    return null;
  }
}

  Future<Profile> fetchProfile(String authToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/me'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body)['data'];
        return Profile.fromJson(responseData);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Exception occurred: $e');
    }
  }

  Future<bool> logout(String authToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/logout'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}



