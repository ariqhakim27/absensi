import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:absensi/widget/AppBarWidget.dart';
import 'package:absensi/widget/DrawerWidget.dart';

class AbsenPage extends StatelessWidget {
  Future<void> submitProblem(String problem, BuildContext context) async {
    final storage = FlutterSecureStorage();
    try {
      final token = await storage.read(key: 'token');

      final Map<String, dynamic> args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final String courseId = args['courseId'];

      final url = Uri.parse(
          'https://backend-pmp.unand.dev/api/my-course/$courseId/problems');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'problem': problem,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Absen berhasil dikirim'),
            duration: Duration(seconds: 3), // Adjust as necessary
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Gagal mengirim Absen: ${response.statusCode}'),
            duration: Duration(seconds: 3), // Adjust as necessary
          ),
        );
      }
    } catch (e) {
      print('Error saat mengirim Absen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat mengirim Absen'),
          duration: Duration(seconds: 3), // Adjust as necessary
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(),
      drawer: MediaQuery.of(context).size.width < 600 ? DrawerWidget() : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return Row(
              children: [
                DrawerWidget(),
                Expanded(
                  child: _buildContent(context),
                ),
              ],
            );
          } else {
            return _buildContent(context);
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String matkul = args['courseName'];
    TextEditingController problemController = TextEditingController();

    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Form Pengajuan Absen Kelas",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      matkul,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Absen apa yang Anda hadapi selama matakuliah ini?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: problemController,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Absen Anda...',
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        String problem = problemController.text.trim();
                        if (problem.isNotEmpty) {
                          submitProblem(problem, context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Masukkan Absen terlebih dahulu'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          "Simpan",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
