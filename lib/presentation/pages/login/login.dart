import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';
import '../../widget/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  void _login(String email, String password) async {
    Map<String, dynamic> sendPost = await post(
      context,
      'http://${dotenv.env['API_URL']}/login',
      10,
      <String, dynamic>{
        'email': email,
        'password': password,
      },
      'Gagal Login. Email atau Kata Sandi salah',
      'Login berhasil',
    );

    if (sendPost.isNotEmpty && sendPost['statusCode'] == 200) {
      final token = sendPost['token'];
      final prefs = await SharedPreferences.getInstance();
      final Map<dynamic, dynamic> tokenDecoded = JwtDecoder.decode(token);
      final String id = "${tokenDecoded['id']}";
      final String name = tokenDecoded['name'];
      final String userEmail = tokenDecoded['email'];
      final String telp = tokenDecoded['telephone'] ?? "";
      final String address = tokenDecoded['address'] ?? "";
      final String image = tokenDecoded['image'] ?? "";

      await prefs.setString('token', token);
      await prefs.setString('id', id);
      await prefs.setString('name', name);
      await prefs.setString('email', userEmail);
      await prefs.setString('telp', telp);
      await prefs.setString('address', address);
      await prefs.setString(
        'image',
        image.isNotEmpty
            ? "http://${dotenv.env['API_URL']}/uploads/$image"
            : '',
      );
      Navigator.pushReplacementNamed(context, '/beranda');
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
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       GestureDetector(
                //         onTap: () {
                //           Navigator.pushNamed(context, '/lupa_kata_sandi');
                //         },
                //         child: Text(
                //           'Lupa Kata Sandi?',
                //           style: TextStyle(color: Colors.grey[600]),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                // sign in button
                MyButton(
                  text: 'Masuk',
                  onTap: () {
                    _login(
                      emailController.text,
                      passwordController.text,
                    );
                  },
                  buttonColor: primaryColor,
                  textColor: secondaryColor,
                ),

                const SizedBox(height: 20),
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
