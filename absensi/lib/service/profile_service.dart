import 'package:http/http.dart' as http;
import 'package:absensi/model/profile.dart';

class ProfileService {
  Future<Profile> getProfile(String id) async {
    final response = await http.get(Uri.parse('https://backend-pmp.unand.dev/api/me/$id'));
    if (response.statusCode == 200) {
      return profileFromJson(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<void> updateProfile(Profile profile) async {
    final response = await http.put(
      Uri.parse('https://api.example.com/profiles/${profile.id}'),
      body: profileToJson(profile),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }
}