import 'package:flutter/material.dart';
import 'package:absensi/Pages/ListKelasPage.dart';
import 'package:absensi/Pages/DetailKelasPage.dart';
import 'package:absensi/Pages/historynilai.dart';
import 'package:absensi/Pages/historypermasalahan.dart';
import 'package:absensi/Pages/Login.dart';
import 'package:absensi/Pages/DetailPertemuanPage.dart';
import 'package:absensi/Pages/AmbilAbsenPage.dart';
import 'package:absensi/Pages/AjuIzin.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sistem Informasi Perkuliahan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFF5FF3),
        ),
        routes: {
          "/": (context) => LoginPage(),
          "Home": (context) => ListKelas(),
          "kelas": (context) => KelasPage(),
          "pertemuan": (context) => PertemuanPage(),
          "absen": (context) => AbsenPage(),
          "izin": (context) => AjuIzinPage(),
          "Historypermasalah": (context) => HistoryPermasalahanPage(),
          "HistoryNilai": (context) => HistoryNilaiPage(),
          
        });
  }
}
