import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';
import '../../widget/textfield.dart';

class HubungiKamiPage extends StatefulWidget {
  final Function()? onTap;
  const HubungiKamiPage({super.key, required this.onTap});

  @override
  State<HubungiKamiPage> createState() => _HubungiKamiPageState();
}

class _HubungiKamiPageState extends State<HubungiKamiPage> {
  final emailController = TextEditingController();
  final problemController = TextEditingController();
  final messageController = TextEditingController();

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
              'Hubungi Kami',
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
                    'assets/images/contact_us.png',
                    width: 200,
                    height: 200,
                  ),
                  // subtitle
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Silakan isi formulir dibawah ini untuk menghubungi kami.\nKami akan menghubungi Anda sesegera mungkin/',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
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
                  // masalah textfield
                  MyTextField(
                    controller: problemController,
                    hintText: 'Masalah',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  // pesan textfield
                  MyTextField(
                    controller: messageController,
                    hintText: 'Pesan',
                    obscureText: false,
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
