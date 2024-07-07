import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:absensi/widget/AppBarWidget.dart';
import 'package:absensi/widget/DrawerWidget.dart';
import 'package:absensi/widget/pertemuanWidget.dart';

class KelasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String matkul = args['courseName'];
    final String className = args['className'];
    final String courseId = args['courseId'];
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double pertemuanWidgetWidth = constraints.maxWidth * 0.9;

          if (constraints.maxWidth >= 600) {
            return Row(
              children: [
                DrawerWidget(), // Sidebar
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
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
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            matkul,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            className,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      "absen",
                                                      arguments: {
                                                        'courseName': matkul,
                                                        'courseId': courseId,
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 5),
                                                    child: Text(
                                                      "Ajukan Izin",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: pertemuanWidgetWidth,
                              child: FutureBuilder<CourseDetail?>(
                                future: fetchCourseDetail(courseId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Center(
                                        child: Text('No data available'));
                                  } else {
                                    return PertemuanWidget(
                                        courseDetail: snapshot.data!);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              matkul,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              className,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        "permasalahan",
                                        arguments: {
                                          'courseName': matkul,
                                          'courseId': courseId,
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      child: Text(
                                        "Lapor",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: pertemuanWidgetWidth,
                  child: FutureBuilder<CourseDetail?>(
                    future: fetchCourseDetail(courseId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text('No data available'));
                      } else {
                        return PertemuanWidget(courseDetail: snapshot.data!);
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      drawer: DrawerWidget(),
    );
  }

  Future<CourseDetail?> fetchCourseDetail(String courseId) async {
    final storage = FlutterSecureStorage();
    try {
      final token = await storage.read(key: 'token');
      final url =
          Uri.parse('https://backend-pmp.unand.dev/api/my-courses/$courseId');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return CourseDetail.fromJson(jsonData);
      } else {
        throw Exception('Failed to load course detail');
      }
    } catch (e) {
      print('Error fetching course detail: $e');
      return null;
    }
  }
}

class CourseDetail {
  final String id;
  final String courseName;
  final int courseCredit;
  final int courseSemester;
  final String className;
  final String? lecturers;
  final int status;
  final List<Meeting> meetings;

  CourseDetail({
    required this.id,
    required this.courseName,
    required this.courseCredit,
    required this.courseSemester,
    required this.className,
    this.lecturers,
    required this.status,
    required this.meetings,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    var meetingsList = json['meetings'] as List;
    List<Meeting> meetings =
        meetingsList.map((meeting) => Meeting.fromJson(meeting)).toList();

    return CourseDetail(
      id: json['id'],
      courseName: json['course_name'],
      courseCredit: json['course_credit'],
      courseSemester: json['course_semester'],
      className: json['class_name'],
      lecturers: json['lecturers'],
      status: json['status'],
      meetings: meetings,
    );
  }
}

class Meeting {
  final String meetingId;
  final int meetNo;
  final String classId;
  final String coursePlanDetailId;
  final String classLecturerId;
  final String materialReal;

  Meeting({
    required this.meetingId,
    required this.meetNo,
    required this.classId,
    required this.coursePlanDetailId,
    required this.classLecturerId,
    required this.materialReal,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      meetingId: json['id'],
      meetNo: json['meet_no'],
      classId: json['class_id'],
      coursePlanDetailId: json['course_plan_detail_id'],
      classLecturerId: json['class_lecturer_id'],
      materialReal: json['material_real'],
    );
  }
}
