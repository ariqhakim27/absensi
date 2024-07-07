import 'package:flutter/material.dart';
import 'package:absensi/widget/AppBarWidget.dart';
import 'package:absensi/widget/DrawerWidget.dart';
import 'package:absensi/widget/MatkulWidget.dart';

class ListKelas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.white, 
  appBar: AppBarWidget(),
  body: SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Row(
            children: [
              DrawerWidget(), // Sidebar
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kelas yang Diambil",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: MatkulWidget(), // MatkulWidget ditampilkan dalam expanded agar dapat di-scroll
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Text(
                  "List Kelas yang Diambil",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              MatkulWidget(),
            ],
          );
        }
      },
    ),
  ),
  drawer: DrawerWidget(),
);
  }
}