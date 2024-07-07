import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MatkulWidget extends StatefulWidget {
  @override
  _MatkulWidgetState createState() => _MatkulWidgetState();
}

class _MatkulWidgetState extends State<MatkulWidget> {
  List<Course> courses = [];
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> fetchCourses() async {
    try {
      String? token = await getToken();
      if (token == null) {
        throw Exception('Token is null');
      }

      final url = Uri.parse('https://backend-pmp.unand.dev/api/my-courses');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<Course> fetchedCourses = [];
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'success') {
          List<dynamic> coursesData = jsonData['courses'];

          for (var courseData in coursesData) {
            fetchedCourses.add(Course.fromJson(courseData));
          }

          setState(() {
            courses = fetchedCourses;
          });
        } else {
          throw Exception('Failed to load courses');
        }
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('Error fetching courses: $e');
      // Handle error accordingly
    }
  }

  Widget _buildMatkulCard(BuildContext context, String courseName, int courseCredit,
      String className, String semester) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxWidth = screenWidth * 0.9; // Using 90% of screen width

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "kelas", arguments: {
            'courseName': courseName,
            'course_credit': courseCredit,
            'className': className,
            'courseId': courses
                .firstWhere((course) => course.courseName == courseName)
                .id,
          });
        },
        child: Container(
          width: boxWidth,
          height: 150,
          decoration: BoxDecoration(
            color: Color(0xff58923B),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' Mata Kuliah : $courseName',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Jumlah SKS : $courseCredit',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Kelas : $className',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Semester: $semester',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: courses.map((course) {
            return _buildMatkulCard(
              context,
              course.courseName,
              course.courseCredit,
              course.className,
              course.courseSemester.toString(),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Course {
  final String id;
  final String courseName;
  final int courseCredit;
  final int courseSemester;
  final String className;
  final String? lecturers;
  final int status;

  Course({
    required this.id,
    required this.courseName,
    required this.courseCredit,
    required this.courseSemester,
    required this.className,
    this.lecturers,
    required this.status,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      courseName: json['course_name'],
      courseCredit: json['course_credit'],
      courseSemester: json['course_semester'],
      className: json['class_name'],
      lecturers: json['lecturers'],
      status: json['status'],
    );
  }
}
