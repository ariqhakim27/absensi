import 'package:flutter/material.dart';
import 'package:absensi/Pages/DetailKelasPage.dart';

class PertemuanWidget extends StatelessWidget {
  final CourseDetail courseDetail;

  PertemuanWidget({required this.courseDetail});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: courseDetail.meetings.map((meeting) {
              return SizedBox(
                width: screenWidth, // Lebar disesuaikan dengan lebar layar
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "pertemuan",
                      arguments: {
                        'pertemuan': meeting.meetNo.toString(),
                        'meetingId': meeting.meetingId,
                        'courseId': courseDetail.id,
                        'courseName': courseDetail.courseName,
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pertemuan ${meeting.meetNo.toString()}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            meeting.materialReal,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
