import 'package:flutter/material.dart';
import '../../widget/button.dart';
import 'package:smart_guru/config/theme/colors.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // nama aplikasi
                const Text(
                  'Smart Guru',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 100),
                // logo
                Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: Center(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                const SizedBox(height: 75),
                // teks selamat datang
                const Text(
                  'Selamat Datang',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // subtitle
                const Text(
                  'Mulai perjalananmu bareng Smart Guru buat tingkatin uji pemahaman belajar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 75),
          // button masuk
          MyButton(
            text: 'Masuk',
            onTap: () {
              // Go to signin page
              Navigator.pushNamed(context, '/login');
            },
          ),
          const SizedBox(height: 10),
          // text daftar disini
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Belum punya akun?',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'Daftar disini',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
