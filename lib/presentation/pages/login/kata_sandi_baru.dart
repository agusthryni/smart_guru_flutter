import 'package:flutter/material.dart';
import 'package:smart_guru/presentation/widget/appbar.dart';
import 'package:smart_guru/presentation/widget/button.dart';
import 'package:smart_guru/presentation/widget/textfield.dart';
import '../../../../config/theme/colors.dart';

class KataSandiBaruPage extends StatefulWidget {
  final Function()? onTap;
  const KataSandiBaruPage({super.key, required this.onTap});

  @override
  State<KataSandiBaruPage> createState() => _KataSandiBaruPageState();
}

class _KataSandiBaruPageState extends State<KataSandiBaruPage> {
  final passwordBaruController = TextEditingController();
  final confirmpasswordbaruController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: const CustomAppBar(
            title: 'Buat Kata Sandi Baru', showLeading: true),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // image
                  Image.asset(
                    'assets/images/new_pass.png',
                    width: 200,
                    height: 200,
                  ),
                  // subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Pastikan kata sandi baru berbeda dengan kata sandi sebelumnya ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // new password textfield
                  MyTextField(
                    controller: passwordBaruController,
                    hintText: 'Kata Sandi Baru',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  // confirm new password textfield
                  MyTextField(
                    controller: confirmpasswordbaruController,
                    hintText: 'Konfirmasi Kata Sandi Baru',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // button
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
