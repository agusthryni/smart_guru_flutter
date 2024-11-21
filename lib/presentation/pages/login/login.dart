import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../auth_service.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';
import '../../widget/square_tile.dart';
import '../../widget/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final timeoutDuration = const Duration(seconds: 10);

  void login(String email, String password) async {
    final client = http.Client();

    try {
      final responses = await http
          .post(
            Uri.parse('http://${dotenv.env['API_URL']}/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': email,
              'password': password,
            }),
          )
          .timeout(timeoutDuration);
      if (responses.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // Decode JWT and extract relevant user information (replace with actual claims)
        final data = jsonDecode(responses.body);
        final token = data['token'];
        final Map<dynamic, dynamic> tokenDecoded = JwtDecoder.decode(token);
        final String name =
            tokenDecoded['name']; // Assuming 'name' claim exists in JWT
        final String email =
            tokenDecoded['email']; // Assuming 'email' claim exists in JWT

        // Store user data securely in SharedPreferences
        await prefs.setString('token', token);
        await prefs.setString('name', name);
        await prefs.setString('email', email);

        Navigator.pushReplacementNamed(context, '/beranda');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal Login. Kode kesalahan: ${responses.statusCode}',
            ),
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
      client.close(); // Close the HTTP client to release resources
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
                // nama dan logo aplikasi
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
                SizedBox(height: MediaQuery.of(context).size.height / 10),
                // selamat datang kembali
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Selamat Datang Kembali',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // masuk ke akunmu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Masuk ke akunmu',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Kata Sandi',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/lupa_kata_sandi');
                        },
                        child: Text(
                          'Lupa Kata Sandi?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // sign in button
                MyButton(
                  text: 'Masuk',
                  onTap: () {
                    login(
                      emailController.text,
                      passwordController.text,
                    );
                  },
                  buttonColor: primaryColor,
                  textColor: secondaryColor,
                ),
                const SizedBox(height: 20),
                // or continue with
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[400],
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //         child: Text(
                //           'atau',
                //           style: TextStyle(color: Colors.grey[700]),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[400],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                // // google sign in buttons
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     // google button
                //     SquareTile(
                //       onTap: () => AuthService().signInWithGoogle(),
                //       imagePath: 'assets/icon/google.png',
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 20),
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'Daftar disini',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
