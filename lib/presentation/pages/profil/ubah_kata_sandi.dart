import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';
import '../../widget/textfield.dart';

class UbahKataSandiPage extends StatefulWidget {
  final Function()? onTap;
  const UbahKataSandiPage({super.key, required this.onTap});

  @override
  State<UbahKataSandiPage> createState() => _UbahKataSandiPageState();
}

class _UbahKataSandiPageState extends State<UbahKataSandiPage> {
  final passwordController = TextEditingController();
  final newpasswordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
            backgroundColor: secondaryColor,
            elevation: 0,
            leading: GestureDetector(
                child: const Icon(Icons.arrow_back),
                onTap: () {
                  Navigator.pop(context);
                }),
            title: const Text(
              'Ubah Kata Sandi',
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
                  const SizedBox(height: 20),
                  // password saat ini textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password Saat Ini',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  // password baru textfield
                  MyTextField(
                    controller: newpasswordController,
                    hintText: 'Password Baru',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  // konfirmasi password baru textfield
                  MyTextField(
                    controller: confirmpasswordController,
                    hintText: 'Konfirmasi Password Baru',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  // button simpan
                  MyButton(
                    text: 'Simpan',
                    onTap: () {},
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
