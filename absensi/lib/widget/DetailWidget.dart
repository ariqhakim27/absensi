import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailWidget extends StatefulWidget {
  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  TextEditingController _feedbackController = TextEditingController();
  bool _isLoading = true;
  bool _isFeedbackExist = false;

  @override
  void initState() {
    super.initState();
    _loadExistingFeedback();
  }

  Future<void> _loadExistingFeedback() async {
    setState(() {
      _isFeedbackExist = false;
      _isLoading = false;
    });
  }

  Future<void> submitFeedback(BuildContext context) async {
    final storage = FlutterSecureStorage();
    try {
      final token = await storage.read(key: 'token');
      final Map<String, dynamic> args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final String meetingId = args['meetingId'];
      final String courseId = args['courseId'];

      final url = _isFeedbackExist
          ? Uri.parse(
              'https://backend-pmp.unand.dev/api/my-course/$meetingId/evaluations/$meetingId')
          : Uri.parse(
              'https://backend-pmp.unand.dev/api/my-course/$courseId/evaluations');

      final response = _isFeedbackExist
          ? await http.put(
              url,
              headers: <String, String>{
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'feedback': _feedbackController.text,
              }),
            )
          : await http.post(
              url,
              headers: <String, String>{
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'feedback': _feedbackController.text,
                'meeting_id': meetingId,
              }),
            );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isFeedbackExist
                ? 'Edit feedback berhasil disimpan'
                : 'Feedback berhasil disimpan'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context); // Navigate back after success
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Gagal menyimpan feedback: ${response.statusCode}'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      print('Error saat menyimpan feedback: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat menyimpan feedback'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxWidth = screenWidth * 0.9;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(

            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: boxWidth,
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
                          "Catatan Dosen dari pertemuan ini",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _feedbackController,
                          decoration: InputDecoration(
                            hintText: 'Belum ada Komentar',
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ],
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
                            submitFeedback(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
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
          );
  }
}