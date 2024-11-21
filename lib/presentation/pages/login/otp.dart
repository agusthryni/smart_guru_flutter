import 'package:flutter/material.dart';
import 'package:smart_guru/presentation/widget/button.dart';
import 'package:smart_guru/presentation/widget/otp_tile.dart';
import '../../../../config/theme/colors.dart';

class OTPPage extends StatefulWidget {
  final Function()? onTap;
  const OTPPage({super.key, required this.onTap});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final pinCodeController = TextEditingController();

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
              'Verifikasi Email',
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
                    'assets/images/otp.png',
                    width: 200,
                    height: 200,
                  ),
                  // subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Masukkan kode verifikasi yang dikirim ke agus@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Pin code tiles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PinCodeTile(
                        controller: pinCodeController,
                        length: 1,
                        onCompleted: (code) => {},
                      ),
                      const SizedBox(width: 10.0),
                      PinCodeTile(
                        controller: pinCodeController,
                        length: 1,
                        onCompleted: (code) => {},
                      ),
                      const SizedBox(width: 10.0),
                      PinCodeTile(
                        controller: pinCodeController,
                        length: 1,
                        onCompleted: (code) => {},
                      ),
                      const SizedBox(width: 10.0),
                      PinCodeTile(
                        controller: pinCodeController,
                        length: 1,
                        onCompleted: (code) => {},
                      ),
                    ],
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
