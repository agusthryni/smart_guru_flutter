import 'package:flutter/material.dart';
import 'package:smart_guru/presentation/widget/button.dart';
import 'package:smart_guru/presentation/widget/textfield.dart';
import '../../../../config/theme/colors.dart';

class LupaKataSandiPage extends StatefulWidget {
  final Function()? onTap;
  const LupaKataSandiPage({super.key, required this.onTap});

  @override
  State<LupaKataSandiPage> createState() => _LupaKataSandiPageState();
}

class _LupaKataSandiPageState extends State<LupaKataSandiPage> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
            backgroundColor: secondaryColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text(
              'Lupa Kata Sandi',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            centerTitle: true),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // image
                  Image.asset(
                    'assets/images/change_pass.png',
                    width: 200,
                    height: 200,
                  ),
                  // subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Masukkan alamat email terdaftar untuk menerima kode verifikasi',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // password textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),

                  // button
                  MyButton(
                    text: 'Kirim',
                    onTap: () {
                      Navigator.pushNamed(context, '/otp');
                    },
                    buttonColor: primaryColor,
                    textColor: secondaryColor,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
