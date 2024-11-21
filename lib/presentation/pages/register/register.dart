import 'package:flutter/material.dart';
import 'package:smart_guru/auth_service.dart';
import 'package:smart_guru/config/theme/colors.dart';
import 'package:smart_guru/presentation/widget/square_tile.dart';
import '../../widget/button.dart';
import '../../widget/textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register(String nama, String email, String password,
      String confirmPassword) async {
    final client = http.Client();
    const timeoutDuration = Duration(seconds: 10);

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan Konfirmasi Password tidak sesuai'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      final responses = await http
          .post(
            Uri.parse('http://${dotenv.env['API_URL']}/register'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'name': nama,
              'email': email,
              'password': password,
              'verify_password': confirmPassword
            }),
          )
          .timeout(timeoutDuration);
      if (responses.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akun berhasil dibuat!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamed(context, '/login');
      } else if (responses.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Terjadi kesalahan pada server. Silakan coba lagi nanti.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Gagal membuat akun. Kode kesalahan: ${responses.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request timed out. Periksa koneksi internet Anda.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // logo dan nama aplikasi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icon/logo.png',
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Smart Guru',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 15),
                // teks selamat datang
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Selamat Datang',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // teks buat akun baru
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Buat akun baru',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // nama lengkap textfield
                MyTextField(
                  controller: nameController,
                  hintText: 'Nama Lengkap',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                // kata sandi textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Kata Sandi',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                // konfirmasi password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Konfirmasi Kata Sandi',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                // sign up button
                MyButton(
                    text: "Daftar",
                    onTap: () {
                      register(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                          confirmPasswordController.text);
                    },
                    buttonColor: primaryColor,
                    textColor: secondaryColor),
                const SizedBox(height: 20),
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'atau',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // google sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'assets/icon/google.png'),
                  ],
                ),
                const SizedBox(height: 20),
                // already an have account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Masuk disini',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
