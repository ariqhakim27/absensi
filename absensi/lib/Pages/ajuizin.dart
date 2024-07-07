import 'package:flutter/material.dart';
import 'package:absensi/pages/detailkelaspage.dart';

class AjuIzinPage extends StatefulWidget {
  const AjuIzinPage({Key? key}) : super(key: key);

  @override
  _AjuIzinPageState createState() => _AjuIzinPageState();
}

class _AjuIzinPageState extends State<AjuIzinPage> {
  final List<String> izinItems = ['Sakit', 'Izin'];
  final valueListenable = ValueNotifier<String?>(null);

  final _formKey = GlobalKey<FormState>();

  String alasan = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        key: _formKey,
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            SizedBox(
              height: 16,
            ),
            Text(
              'Jenis Izin',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              hint: const Text(
                '   Pilih Izin',
                style: TextStyle(fontSize: 14),
              ),
              items: izinItems
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: valueListenable.value,
              validator: (value) {
                if (value == null) {
                  return 'Pilih izin.';
                }
                return null;
              },
              onChanged: (value) {
                valueListenable.value = value;
              },
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          'Masukkan alasan anda tidak bisa hadir pertemuan saat ini',
                    ),
                    onChanged: (value) {
                      setState(() {
                        alasan = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Foto Bukti Izin/Sakit',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                // Aksi yang ingin dilakukan ketika tombol diklik
              },
              child: Container(
                width: 200,
                height: 267,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 64,
                      color: Colors.grey[500],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Pilih Gambar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KelasPage()),
                );
                print('Alasan: $alasan');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: const Color(0xFFE74C3C),
              ),
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'Ajukan Izin',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
