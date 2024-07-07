import 'package:flutter/material.dart';
import 'package:absensi/widget/AppBarWidget.dart';
import 'package:absensi/widget/DrawerWidget.dart';
import 'package:absensi/widget/historynilai.dart';

class HistoryNilaiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          AppBarWidget(),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    "History",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Penilaian Pertemuan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          historynilaiwidget(),
        ],
      ),
      drawer: DrawerWidget(),
    );
  }
}
