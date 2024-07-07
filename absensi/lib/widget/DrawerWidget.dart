import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final storage = FlutterSecureStorage();
  String name = '';
  String nim = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token is null');
      }

      final url = Uri.parse('https://backend-pmp.unand.dev/api/me');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          name = jsonData['data']['name'];
          nim = jsonData['data']['nim'];
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Handle error accordingly
    }
  }

  Future<void> logout() async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token is null');
      }

      final url = Uri.parse('https://backend-pmp.unand.dev/api/logout');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Clear token from local storage
        await storage.delete(key: 'token');
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      print('Error during logout: $e');
      // Handle error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            
            decoration: BoxDecoration(
              color: Color(0xff58923B),
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage:
                      AssetImage("assets/images/image 1.png"), // Ganti dengan asset gambar Anda
                ),
                SizedBox(height: 20),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  nim,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, "Home");
            },
            leading: Icon(
              CupertinoIcons.house_alt_fill,
              color: Colors.green,
            ),
            title: Text(
              "Halaman Utama",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          ListTile(
            onTap: () {
              logout();
            },
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text(
              "Keluar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
