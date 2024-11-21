import 'package:flutter/material.dart';
import 'package:smart_guru/config/theme/colors.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import 'package:smart_guru/presentation/service/snackbar.dart';
import '../../widget/button.dart';
import '../../widget/textfield.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    if (passwordController.text != confirmPasswordController.text) {
      showCustomSnackBar(
          context, 'Password dan Konfirmasi Password tidak sesuai', false);
      return;
    }
    Map<String, dynamic> sendPost = await post(
      context,
      'http://${dotenv.env['API_URL']}/register',
      10,
      <String, dynamic>{
        'name': nama,
        'email': email,
        'password': password,
        'verify_password': confirmPassword
      },
      'Gagal membuat akun',
      'Akun berhasil dibuat!',
    );
    if (sendPost.isNotEmpty && sendPost['statusCode'] == 200) {
      Navigator.pop(context);
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
