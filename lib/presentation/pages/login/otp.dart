import 'package:flutter/material.dart';
import 'package:smart_guru/presentation/widget/appbar.dart';
import 'package:smart_guru/presentation/widget/button.dart';
import '../../../../config/theme/colors.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OTPPage extends StatefulWidget {
  final Function()? onTap;
  const OTPPage({super.key, required this.onTap});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar:
            const CustomAppBar(title: 'Verifikasi Email', showLeading: true),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // image
                  Image.asset(
                    'assets/images/otp.png',
                    width: 200,
                    height: 200,
                  ),
                  // subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Masukkan kode verifikasi yang dikirim ke email@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  OtpTextField(
                    numberOfFields: 4,
                    borderColor: const Color(0xFF283D72),
                    showFieldAsBox: true,
                    onCodeChanged: (String code) {},
                    onSubmit: (String verificationCode) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Verification Code"),
                              content:
                                  Text('Code entered is $verificationCode'),
                            );
                          });
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Kirim ulang',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // button
                  MyButton(
                    text: 'Verifikasi',
                    onTap: () {
                      Navigator.pushNamed(context, '/kata_sandi_baru');
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
