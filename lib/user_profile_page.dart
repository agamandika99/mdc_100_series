import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60, // Sesuaikan dengan ukuran gambar
              child: ClipOval(
                child: Image.asset(
                  'assets/foto.png',
                  fit: BoxFit.cover, // Sesuaikan dengan ukuran lingkaran avatar
                  width: 120, // Lebar gambar
                  height: 160, // Tinggi gambar
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Agam Andika',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '221511001',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Nomor Telepon: 0895344350956',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
