import 'package:flutter/material.dart';
import 'package:absensi/Pages/ListKelasPage.dart'; // Ganti dengan import yang sesuai
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/unand.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Container(
                          color:  const Color(0xff58923B).withOpacity(0.3),
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Sistem Informasi Perkuliahan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 300),
                                  Text(
                                    'Selamat Datang',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  
                                ],
                              ),
                              SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: LoginForm(),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: LoginForm(),
          );
        }
      },
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  final storage = FlutterSecureStorage();

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://backend-pmp.unand.dev/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      // Jika server mengembalikan respons OK, parse JSON
      final responseData = jsonDecode(response.body);
      String token = responseData['data']['authorization']['token'];

      // Simpan token menggunakan flutter_secure_storage
      await storage.write(key: 'token', value: token);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListKelas()),
      );
    } else {
      showDialog(
        context: context,
        builder: (content) => AlertDialog(
          title: Text("Error"),
          content: Text("Email & password salah"),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      height: MediaQuery.of(context).size.height - 50,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Silahkan Masuk",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Masuk dengan menggunakan Email Kampus",
            style: TextStyle(
                fontSize: 15, color: Colors.grey[700], fontFamily: 'Poppins'),
          ),
          SizedBox(
            height: 30,
          ),
          makeInput(label: "Masukkan Email Anda", controller: emailController),
          makeInput(
              label: "Masukkan Password Anda",
              obscureText: true,
              controller: passwordController),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 3, left: 3, bottom: 2, right: 2),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: isLoading ? null : login,
              color: Color(0xff58923B),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      'Masuk',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Poppins'),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget makeInput(
      {label, obscureText = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
